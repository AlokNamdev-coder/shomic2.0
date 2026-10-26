package handlers

import (
	"context"
	"shomic/database"
	"shomic/models"
	"shomic/services"
	"time"

	"github.com/gofiber/fiber/v2"
)

func CreateSearchHistory(c *fiber.Ctx) error {

	var history models.SearchHistory

	if err := c.BodyParser(&history); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid Request Body",
		})
	}

	_, err := database.DB.Exec(
		context.Background(),

		`INSERT INTO search_history
		(
			id,
			user_id,
			query,
			result_type,
			result_id
		)
		VALUES
		(
			$1,$2,$3,$4,$5
		)`,

		history.ID,
		history.UserID,
		history.Query,
		history.ResultType,
		history.ResultID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Search history stored successfully",
	})
}

func GetSearchHistory(c *fiber.Ctx) error {

	userID := c.Params("id")

	limit := c.QueryInt("limit", 20)

	cursorTimeStr := c.Query("cursor_time")
	cursorID := c.Query("cursor_id")

	cacheKey:="history"+userID

	if (cursorTimeStr == "") != (cursorID == "") {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cursor_time and cursor_id must be provided together",
		})
	}

	var (
		rows interface {
			Next() bool
			Scan(...any) error
			Close()
		}
		err error
	)

	if cursorTimeStr == "" {

		var cachedResponse fiber.Map

		if services.CacheExist(cacheKey){
			services.GetCache(cacheKey,&cachedResponse)

			return c.Status(fiber.StatusOK).JSON(cachedResponse)

		}

		rows, err = database.DB.Query(
			context.Background(),

			`SELECT
				id,
				user_id,
				query,
				result_type,
				result_id,
				created_at
			FROM search_history
			WHERE user_id = $1
			ORDER BY created_at DESC, id DESC
			LIMIT $2`,

			userID,
			limit,
		)

	} else {

		cursorTime, err := time.Parse(time.RFC3339, cursorTimeStr)
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"error": "Invalid cursor_time",
			})
		}

		rows, err = database.DB.Query(
			context.Background(),

			`SELECT
				id,
				user_id,
				query,
				result_type,
				result_id,
				created_at
			FROM search_history
			WHERE user_id = $1
			AND (created_at,id) < ($2,$3)
			ORDER BY created_at DESC, id DESC
			LIMIT $4`,

			userID,
			cursorTime,
			cursorID,
			limit,
		)
	}

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	defer rows.Close()

	var history []models.SearchHistory

	for rows.Next() {

		var item models.SearchHistory

		err := rows.Scan(
			&item.ID,
			&item.UserID,
			&item.Query,
			&item.ResultType,
			&item.ResultID,
			&item.CreatedAt,
		)

		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": err.Error(),
			})
		}

		history = append(history, item)
	}

	var nextCursorTime string
	var nextCursorID string

	if len(history) > 0 {

		last := history[len(history)-1]

		nextCursorTime = last.CreatedAt.Format(time.RFC3339)
		nextCursorID = last.ID
	}


	response:=fiber.Map{
		"search_history": history,

		"next_cursor": fiber.Map{
			"cursor_time": nextCursorTime,
			"cursor_id":   nextCursorID,
		},

		"has_next": len(history) == limit,
	}


	if cursorTimeStr==""{
		services.SetCache(cacheKey,response,2*time.Minute)
	}

	return c.Status(fiber.StatusOK).JSON(response)
}

func SearchUsers(c *fiber.Ctx) error {

	query := c.Query("q")

	if query == "" {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Search query is required",
		})
	}

	rows, err := database.DB.Query(
		context.Background(),

		`SELECT
			id,
			username,
			profile_picture_url,
			is_verified
		FROM users
		WHERE username ILIKE $1
		ORDER BY username
		LIMIT 20`,

		query+"%",
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	defer rows.Close()

	type SearchUser struct {
		ID                string `json:"id"`
		Username          string `json:"username"`
		ProfilePictureURL string `json:"profile_picture_url"`
		IsVerified        bool   `json:"is_verified"`
	}

	var users []SearchUser

	for rows.Next() {

		var user SearchUser

		err := rows.Scan(
			&user.ID,
			&user.Username,
			&user.ProfilePictureURL,
			&user.IsVerified,
		)

		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": err.Error(),
			})
		}

		users = append(users, user)
	}

	return c.Status(fiber.StatusOK).JSON(users)
}

