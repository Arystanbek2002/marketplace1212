package main

import (
	"bytes"
	b64 "encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"marketplace/pkg/models"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v4"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

type PairResponse struct {
	Access    string    `json:"access"`
	Referesh  string    `json:"refresh"`
	AccessExp time.Time `json:"access_expire_at"`
	ExpiresAt time.Time `json:"refresh_expire_at"`
}

var dummy string = "dummy"

func WriteJSON(w http.ResponseWriter, status int, v any) error {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	err := json.NewEncoder(w).Encode(v)
	if err != nil {
		log.Println(v)
		return fmt.Errorf("encode error")
	}
	return nil
}

func (app *application) generatePair(user_id int) (*PairResponse, string) {
	pair_uuid := uuid.New().String() //identifier of pair
	pair_uuid = strings.Replace(pair_uuid, "-", "", -1)

	refreshEnd := uuid.New().String() //end part of refresh token
	refreshEnd = strings.Replace(refreshEnd, "-", "", -1)

	t := time.Now()
	tAcc := t.Add(10 * time.Minute) //expiration time of access token
	tRef := t.Add(336 * time.Hour)  //expiration time of refresh token

	access, err := generateJWT(user_id, pair_uuid, tAcc, "ACCESS_SECRET") //generate jwt with pair id and user id
	if err != nil {
		return nil, "error while creating JWT"
	}

	refresh := pair_uuid + refreshEnd //refresh token consists of pair id and its own uuid

	bytes, err := bcrypt.GenerateFromPassword([]byte(refresh), 14) //hashing refresh token to store it in bd
	if err != nil {
		return nil, "error while hashing" + err.Error()
	}
	refreshHash := string(bytes)

	tok := &models.RefreshToken{
		UserID:    user_id,
		Token:     refreshHash,
		ExpiresAt: tRef,
	}
	err = app.token.Insert(tok)
	if err != nil {
		if err != models.ErrDuplicateToken {
			return nil, "error while creating token" + err.Error()
		} else {
			err = app.token.Update(tok)
			if err != nil {
				return nil, "error while updating token" + err.Error()
			}
		}
	}

	resp := &PairResponse{
		//encode refresh token to base64
		Referesh:  b64.StdEncoding.EncodeToString([]byte(refresh)), //actually must be in httponly cookie
		Access:    access,
		AccessExp: tAcc,
		ExpiresAt: tRef,
	}
	return resp, ""
}

func (app *application) signupClient(w http.ResponseWriter, r *http.Request) {
	var newClient models.Client

	body, _ := io.ReadAll(r.Body)
	r.Body = io.NopCloser(bytes.NewBuffer(body))

	err := json.NewDecoder(r.Body).Decode(&newClient)

	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	err = app.client.Insert(newClient.Telephone, newClient.Password)
	if err != nil {
		app.serverError(w, err)
		return
	}

	w.WriteHeader(http.StatusCreated) // 201
}

func (app *application) getUserById(w http.ResponseWriter, r *http.Request) {
	userIDStr := r.URL.Query().Get("id")
	if userIDStr == "" {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	user, err := app.client.GetUserById(userIDStr)
	if err != nil {
		if errors.Is(err, models.ErrNoRecord) {
			app.clientError(w, http.StatusNotFound)
		} else {
			app.serverError(w, err)
		}
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(user)
}

func (app *application) signupClientLaw(w http.ResponseWriter, r *http.Request) {
	var newClient models.ClientLaw

	body, _ := io.ReadAll(r.Body)
	r.Body = io.NopCloser(bytes.NewBuffer(body))

	err := json.NewDecoder(r.Body).Decode(&newClient)

	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	err = app.client.InsertLaw(&newClient)
	if err != nil {
		app.serverError(w, err)
		return
	}

	w.WriteHeader(http.StatusCreated) // 201
}

func (app *application) loginClient(w http.ResponseWriter, r *http.Request) {
	var client models.Client

	body, _ := io.ReadAll(r.Body)
	r.Body = io.NopCloser(bytes.NewBuffer(body))

	err := json.NewDecoder(r.Body).Decode(&client)

	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	clientId, err := app.client.Authenticate(client.Password, client.Telephone)
	if err != nil {
		if errors.Is(err, models.ErrInvalidCredentials) {
			app.clientError(w, http.StatusBadRequest)
			return
		} else {
			app.serverError(w, err)

			return
		}
	}

	responseUser, err := app.client.GetUserById(strconv.Itoa(clientId))
	if err != nil {
		app.clientError(w, http.StatusInternalServerError)
		return
	}

	resp, errmMsg := app.generatePair(clientId)
	if errmMsg != "" {
		app.serverError(w, fmt.Errorf(errmMsg))
		return
	}

	cookieAcc := http.Cookie{
		Name:     "x-jwt",
		Value:    resp.Access,
		Path:     "/",
		Expires:  resp.AccessExp,
		HttpOnly: true,
		Secure:   true,
	}
	http.SetCookie(w, &cookieAcc)
	cookieRef := http.Cookie{
		Name:     "x-ref",
		Value:    resp.Referesh,
		Path:     "/",
		Expires:  resp.ExpiresAt,
		HttpOnly: true,
		Secure:   true,
	}
	http.SetCookie(w, &cookieRef)

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	err = json.NewEncoder(w).Encode(responseUser)
	if err != nil {
		log.Println(err)
		return
	}
}

func (app *application) handleRefreshToken(w http.ResponseWriter, r *http.Request) {
	c, err := r.Cookie("x-jwt")
	if err != nil {
		_ = WriteJSON(w, http.StatusUnauthorized, "Error: No cookie")
	}
	tknStr := c.Value

	c, err = r.Cookie("x-ref")
	if err != nil {
		_ = WriteJSON(w, http.StatusUnauthorized, "Error: No cookie")
	}
	refStr := c.Value

	accClaims, err1 := verifyJWT(tknStr, "ACCESS_SECRET")
	//check if token error due to expiration and not signature invalidness
	//even if access token expired, user still can refresh token if it's valid
	//don't check token for validity because it will generate error anyway if not valid
	if err1 != nil && !errors.Is(err1, jwt.ErrTokenExpired) {
		WriteJSON(w, http.StatusBadRequest, "invalid token access "+err1.Error())
		return
	}

	refreshByte, err := b64.StdEncoding.DecodeString(refStr) //decoding refresh token
	if err != nil {
		WriteJSON(w, http.StatusBadRequest, fmt.Sprintf("decoding error %s", err.Error()))
		return
	}
	refStr = string(refreshByte)
	//UUID and GUID is the same thing, but in this context GUID user id and UUID pair identifier
	//checks if pair identifier is same
	if refStr[:32] != accClaims.UUID {
		//user can't edit access token without making jwt invalid
		//also he can't edit refresh token, since it kept in bd and won't match
		_ = WriteJSON(w, http.StatusBadRequest, "invalid token pair")

	}
	//retrieves user data from bd
	tok, err := app.token.GetByUserID(accClaims.UserID)
	if err != nil {
		_ = WriteJSON(w, http.StatusBadRequest, err.Error())
		return
	}
	//if instead of refresh token there is dummy value means that refresh token expired or token pair was stolen
	if tok.Token == dummy {
		_ = WriteJSON(w, http.StatusBadRequest, "refresh token no longer valid, login again")
		return
	}
	if time.Now().After(tok.ExpiresAt) {
		//if refresh token expired, turn refresh token to dummy and delete token family
		err = app.token.Update(&models.RefreshToken{UserID: accClaims.UserID, Token: dummy, ExpiresAt: tok.ExpiresAt})
		if err != nil {
			log.Printf("error while changing refresh Token to Dummy %s", err.Error())
			_ = WriteJSON(w, http.StatusInternalServerError, "smth went wrong")
			return
		}
		WriteJSON(w, http.StatusBadRequest, "refresh token expired, login again")
		return
	}
	//comparing 2 hash refresh tokens
	err = bcrypt.CompareHashAndPassword([]byte(tok.Token), refreshByte)
	if err != nil {
		WriteJSON(w, http.StatusBadRequest, "refresh token invalid, login again")
		return
	}
	//if everything ok return 2 new tokens, old token becomes invalid
	app.generatePair(accClaims.UserID)
}

func (app *application) loginAdmin(w http.ResponseWriter, r *http.Request) {
	var client models.Client

	body, _ := io.ReadAll(r.Body)
	r.Body = io.NopCloser(bytes.NewBuffer(body))

	err := json.NewDecoder(r.Body).Decode(&client)

	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	clientId, err := app.client.AuthenticateAdmin(client.Telephone, client.Password)
	if err != nil {
		if errors.Is(err, models.ErrInvalidCredentials) {
			app.clientError(w, http.StatusBadRequest)
			return
		} else {
			app.serverError(w, err)

			return
		}
	}

	responseUser, err := app.client.GetUserByIdAdmin(strconv.Itoa(clientId))

	_, err = w.Write(responseUser)
	if err != nil {
		return
	}
}

// RECOVERY

// Recovery

func (app *application) Recoverybysms(w http.ResponseWriter, r *http.Request) {

	cookie, err := r.Cookie("idclient")
	if err != nil {
		http.Error(w, "Ошибка получения cookie", http.StatusBadRequest)
		return
	}

	idclient := cookie.Value

	clientphone, err := app.client.GetClientPhoneById(idclient)

	fmt.Print(clientphone)

	if err != nil {
		http.Error(w, "Error", http.StatusInternalServerError)
		return
	}

	//link := fmt.Sprintf("http://localhost:4000/client-password-recovery?id=%s", idclient)

	//sendSMS(clientphone, link)

}

func (app *application) updatePassword(w http.ResponseWriter, r *http.Request) {

	id_string := r.URL.Query().Get("id")

	id, err := strconv.Atoi(id_string)

	if err != nil {
		app.clientError(w, http.StatusInternalServerError)
		return
	}

	type pass struct {
		OldPassword string `json:"oldpassword"`
		NewPassword string `json:"newpassword"`
	}
	var clientpass pass

	body, _ := io.ReadAll(r.Body)
	r.Body = io.NopCloser(bytes.NewBuffer(body))

	err = json.NewDecoder(r.Body).Decode(&clientpass)
	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	err = app.client.ChangePassword(id, clientpass.OldPassword, clientpass.NewPassword)
	if err != nil {
		app.serverError(w, err)
		return
	}

	w.WriteHeader(http.StatusOK) // 200
}
