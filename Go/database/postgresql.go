package database

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
)

var DB *pgx.Conn

func ConnectDB() {
	var err error

	DB, err = pgx.Connect(
		context.Background(),
		"postgres://postgres:Ram@localhost:5432/Shomic2",
	)

	if err != nil {
		panic(err)
	}

	fmt.Println("Successfully Connected to Postgresql", DB)
	fmt.Printf("The address of this DbConnect is %p", DB)

}

func CloseDB() {
	if DB != nil {
		DB.Close(context.Background())
	}
}
