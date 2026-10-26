package models

import "time"

type SearchHistory struct {
	ID     string `json:"id"`
	UserID string `json:"user_id"`

	Query string `json:"query"`

	ResultType string `json:"result_type"`

	ResultID string `json:"result_id"`

	CreatedAt time.Time `json:"created_at"`
}
