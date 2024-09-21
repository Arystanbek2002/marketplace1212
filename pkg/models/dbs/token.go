package dbs

import (
	"database/sql"
	"errors"
	"marketplace/pkg/models"

	"github.com/go-sql-driver/mysql"
)

type TokenModel struct {
	DB *sql.DB
}

func (t *TokenModel) Insert(tok *models.RefreshToken) error {
	stmt := `
    	INSERT INTO refresh_tokens
    	(user_id, token, expires_at)
    	VALUES (?, ?, ?);`

	_, err := t.DB.Exec(stmt, tok.UserID, tok.Token, tok.ExpiresAt)
	if err != nil {
		if mysqlErr, ok := err.(*mysql.MySQLError); ok && mysqlErr.Number == 1062 {
			return models.ErrDuplicateToken
		}
	}

	return err
}

func (t *TokenModel) Update(tok *models.RefreshToken) error {
	stmt := `
    UPDATE refresh_tokens
    SET token = ?, expires_at = ?
    WHERE user_id = ?;`

	_, err := t.DB.Exec(stmt, tok.Token, tok.ExpiresAt, tok.UserID)

	return err
}

func (t *TokenModel) GetByUserID(user_id int) (*models.RefreshToken, error) {
	stmt := `
        SELECT token, expires_at
        FROM refresh_tokens
        WHERE user_id = ?;`

	row, err := t.DB.Query(stmt, user_id)
	if err != nil {
		return nil, err
	}
	defer row.Close()

	tok := &models.RefreshToken{
		UserID: user_id,
	}

	err = row.Scan(&tok.Token, &tok.ExpiresAt)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, models.ErrNoRecord
		} else {
			return nil, err
		}
	}

	return tok, nil
}
