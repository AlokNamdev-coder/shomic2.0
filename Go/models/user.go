package models

import "time"

type User struct {
	ID                string     `json:"id"`
	Username          string    `json:"username"`
	Email             string    `json:"email"`
	PasswordHash      string    `json:"password_hash"`
	FullName          string    `json:"full_name"`
	Bio               string    `json:"bio"`
	Phone             string    `json:"phone"`
	Country           string    `json:"country"`
	City              string    `json:"city"`
	BirthDate         time.Time `json:"birth_date"`
	ProfilePictureURL string    `json:"profile_picture_url"`
	CoverPictureURL   string    `json:"cover_picture_url"`

	Gender string `json:"gender"`

	IsVerified bool `json:"is_verified"`
	IsPrivate  bool `json:"is_private"`

	FollowersCount int64 `json:"followers_count"`
	FollowingCount int64 `json:"following_count"`
	PostsCount     int64 `json:"posts_count"`

	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}