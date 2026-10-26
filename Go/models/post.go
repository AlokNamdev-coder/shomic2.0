package models

import "time"

type Post struct {
	ID           string `json:"id"`
	UserID       string `json:"user_id"`
	Caption      string `json:"caption"`
	MediaURL     string `json:"media_url"`
	ThumbnailURL string `json:"thumbnail_url"`
	MediaType    string `json:"media_type"`
	Location     string `json:"location"`

	LikesCount    int64 `json:"likes_count"`
	CommentsCount int64 `json:"comments_count"`
	SharesCount   int64 `json:"shares_count"`
	ViewsCount    int64 `json:"views_count"`

	IsEdited  bool `json:"is_edited"`
	IsDeleted bool `json:"is_deleted"`

	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type CreatePostRequest struct {
	ID           string `json:"id"`
	UserID       string `json:"user_id"`
	Caption      string `json:"caption"`
	MediaURL     string `json:"media_url"`
	ThumbnailURL string `json:"thumbnail_url"`
	MediaType    string `json:"media_type"`
	Location     string `json:"location"`
}
