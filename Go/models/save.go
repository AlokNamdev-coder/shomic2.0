package models

import "time"

type Save struct {
	UserID    string    `json:"user_id"`
	PostID    string    `json:"post_id"`
	CreatedAt time.Time `json:"created_at"`
}



type SavedPost struct {
	SavedAt time.Time `json:"saved_at"`

	Post Post `json:"post"`
}