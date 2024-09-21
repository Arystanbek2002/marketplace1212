package main

import (
	"database/sql"
	"flag"
	"html/template"
	"log"
	"marketplace/pkg/models/dbs"
	"net/http"
	"os"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/golang-jwt/jwt/v4"
	"github.com/golangcollege/sessions"
	"github.com/rs/cors"
)

type application struct {
	errorLog      *log.Logger
	infoLog       *log.Logger
	session       *sessions.Session
	templateCache map[string]*template.Template
	client        *dbs.ClientModel
	product       *dbs.ProductModel
	fav           *dbs.FavModel
	details       *dbs.InformationModel
	image         *dbs.ImageModel
	order         *dbs.OrderModel
	cart          *dbs.CartModel
	discount      *dbs.DiscountModel
	token         *dbs.TokenModel
}

type Claims struct {
	UserID int    `json:"user_id"`
	UUID   string `json:"uuid"`
	jwt.RegisteredClaims
}

func generateJWT(user_id int, uuid string, t time.Time, secretName string) (string, error) {
	claims := &Claims{
		UserID: user_id,
		UUID:   uuid,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(t),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS512, claims)
	tokenString, err := token.SignedString([]byte(os.Getenv(secretName)))
	if err != nil {
		return "", err
	}
	return tokenString, nil
}

func verifyJWT(jwtString, secret string) (*Claims, error) {
	claims := &Claims{}
	_, err := jwt.ParseWithClaims(jwtString, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(os.Getenv(secret)), nil
	})
	return claims, err
}

func main() {
	dsn := "root:@tcp(localhost:3307)/marketplace"
	addr := flag.String("addr", ":4000", "HTTP network address")

	secret := flag.String("secret", "s6Ndh+pPbnzHbS*+9Pk8qGWhTzbpa@ge", "Secret key")

	flag.Parse()

	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"http://localhost:3000", "http://localhost"},
		AllowedMethods:   []string{"GET", "HEAD", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"},
		AllowCredentials: true,
	})

	infoLog := log.New(os.Stdout, "INFO\t", log.Ldate|log.Ltime)
	errorLog := log.New(os.Stderr, "ERROR\t", log.Ldate|log.Ltime|log.Lshortfile)

	db, err := openDB(dsn)
	if err != nil {
		errorLog.Fatal(err)
	}
	defer db.Close()

	session := sessions.New([]byte(*secret))
	session.Lifetime = 12 * time.Hour

	app := &application{
		errorLog: errorLog,
		infoLog:  infoLog,
		session:  session,

		client:   &dbs.ClientModel{DB: db},
		token:    &dbs.TokenModel{DB: db},
		product:  &dbs.ProductModel{DB: db},
		fav:      &dbs.FavModel{DB: db},
		details:  &dbs.InformationModel{DB: db},
		image:    &dbs.ImageModel{DB: db},
		order:    &dbs.OrderModel{DB: db},
		cart:     &dbs.CartModel{DB: db},
		discount: &dbs.DiscountModel{DB: db},
	}

	srv := &http.Server{
		Addr:     *addr,
		ErrorLog: errorLog,
		Handler:  c.Handler(app.routes()),
		// TLSConfig:    tlsConfig,
		IdleTimeout:  time.Minute,
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
	}

	infoLog.Printf("Starting server on %s", *addr)

	err = srv.ListenAndServe()
	errorLog.Fatal(err)
}

func openDB(dsn string) (*sql.DB, error) {
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		return nil, err
	}
	if err = db.Ping(); err != nil {
		return nil, err
	}

	return db, nil
}
