package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"io"
	"marketplace/pkg/models"
	"net/http"
	"strconv"

	"github.com/golang-jwt/jwt/v4"
)

func (app *application) addCartItem(w http.ResponseWriter, r *http.Request) {
	c, err := r.Cookie("x-jwt")
	if err != nil {
		_ = WriteJSON(w, http.StatusUnauthorized, "Error: No cookie")
	}
	tknStr := c.Value

	_, err1 := verifyJWT(tknStr, "ACCESS_SECRET")
	if err1 != nil && !errors.Is(err1, jwt.ErrTokenExpired) {
		_ = WriteJSON(w, http.StatusBadRequest, "invalid token access "+err1.Error())
		return
	} else if err1 != nil {
		_ = WriteJSON(w, http.StatusForbidden, "refresh your token")
		return
	}

	var newCartItem models.Cart

	body, _ := io.ReadAll(r.Body)
	r.Body = io.NopCloser(bytes.NewBuffer(body))

	err = json.NewDecoder(r.Body).Decode(&newCartItem)
	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	err = app.cart.Insert(&newCartItem)
	if err != nil {
		app.serverError(w, err)
		return
	}

	w.WriteHeader(http.StatusCreated)
}

func (app *application) getCartItems(w http.ResponseWriter, r *http.Request) {
	clientIDStr := r.URL.Query().Get("client_id")
	if clientIDStr == "" {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	clientID, err := strconv.Atoi(clientIDStr)
	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	cartItems, err := app.cart.GetByClientID(clientID)
	if err != nil {
		app.serverError(w, err)
		return
	}

	response, err := json.Marshal(cartItems)
	if err != nil {
		app.serverError(w, err)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(response)
}

func (app *application) deleteCartItem(w http.ResponseWriter, r *http.Request) {
	clientIDStr := r.URL.Query().Get("client_id")
	productIDStr := r.URL.Query().Get("product_id")
	if clientIDStr == "" || productIDStr == "" {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	clientID, err := strconv.Atoi(clientIDStr)
	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	productID, err := strconv.Atoi(productIDStr)
	if err != nil {
		app.clientError(w, http.StatusBadRequest)
		return
	}

	err = app.cart.Delete(clientID, productID)
	if err != nil {
		app.serverError(w, err)
		return
	}

	w.WriteHeader(http.StatusNoContent) // 204
}
