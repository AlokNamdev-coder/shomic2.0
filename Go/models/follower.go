package models

import "time"

type Follower struct {
	FollowerID string    `json:"follower_id"`
	FollowingID string   `json:"following_id"`
	CreatedAt  time.Time `json:"created_at"`
}