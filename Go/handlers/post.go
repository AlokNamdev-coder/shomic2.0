package handlers

import (
	"context"
	"fmt"
	"shomic/database"
	"shomic/models"
	"shomic/services"
	"time"

	"github.com/gofiber/fiber/v2"
)

func CreatePost(c *fiber.Ctx) error {
	var post models.CreatePostRequest

	err := c.BodyParser(&post)

	if err != nil {
		c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid Body Request",
		})
	}

	_, error := database.DB.Exec(
		context.Background(),
		`INSERT INTO posts
		(

		id,
		user_id,
		caption,
		media_url,
		thumbnail_url,
		media_type,
		location
		)
		INTO VALUES 
		($1,$2,$3,$4,$5,$6,$7)
		`, post.ID, post.UserID, post.Caption, post.MediaURL, post.ThumbnailURL, post.MediaType, post.Location,
	)

	if error != nil {
		return c.JSON(fiber.Map{
			"error": error.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Successfully Created Post",
	})

}

func DeletePost(c *fiber.Ctx) error {
	Id := c.Params("id")

	CommandTag, err := database.DB.Exec(
		context.Background(),
		`DELETE FROM posts WHERE id = $1`, Id,
	)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	if CommandTag.RowsAffected() == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "No Rows Found",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Successfully Deleted The User",
	})

}

func GetPost(c *fiber.Ctx) error {

	var post models.Post

	id := c.Params("id")

	err := database.DB.QueryRow(
		context.Background(),

		`SELECT
			id,
			user_id,
			caption,
			media_url,
			thumbnail_url,
			media_type,
			location,
			likes_count,
			comments_count,
			shares_count,
			views_count,
			is_edited,
			is_deleted,
			created_at,
			updated_at
		FROM posts
		WHERE id = $1`,

		id,
	).Scan(
		&post.ID,
		&post.UserID,
		&post.Caption,
		&post.MediaURL,
		&post.ThumbnailURL,
		&post.MediaType,
		&post.Location,
		&post.LikesCount,
		&post.CommentsCount,
		&post.SharesCount,
		&post.ViewsCount,
		&post.IsEdited,
		&post.IsDeleted,
		&post.CreatedAt,
		&post.UpdatedAt,
	)

	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Post not found",
		})
	}

	return c.Status(fiber.StatusOK).JSON(post)
}

type UpdatePostField struct {
	Value interface{} `json:"value"`
}

func UpdatePost(c *fiber.Ctx) error {

	id := c.Params("id")
	field := c.Params("field")

	allowedFields := map[string]bool{
		"caption":       true,
		"media_url":     true,
		"thumbnail_url": true,
		"media_type":    true,
		"location":      true,
		"is_edited":     true,
	}

	if !allowedFields[field] {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid field name",
		})
	}

	var body UpdatePostField

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	query := fmt.Sprintf(
		`UPDATE posts
		 SET %s = $1,
		     updated_at = CURRENT_TIMESTAMP
		 WHERE id = $2`,
		field,
	)

	commandTag, err := database.DB.Exec(
		context.Background(),
		query,
		body.Value,
		id,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	if commandTag.RowsAffected() == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Post not found",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": fmt.Sprintf("%s updated successfully", field),
	})
}

func GetUserPosts(c *fiber.Ctx) error {

	userID := c.Params("id")

	limit := c.QueryInt("limit", 20)

	cursorTimeStr := c.Query("cursor_time")
	cursorID := c.Query("cursor_id")

	if (cursorTimeStr == "") != (cursorID == "") {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cursor_time and cursor_id must be provided together",
		})
	}

	cacheKey := "user_posts:" + userID

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

		if services.CacheExist(cacheKey) {
			services.GetCache(cacheKey, &cachedResponse)

			return c.Status(fiber.StatusOK).JSON(cachedResponse)
		}

		rows, err = database.DB.Query(
			context.Background(),

			`SELECT
				id,
				user_id,
				caption,
				media_url,
				thumbnail_url,
				media_type,
				location,
				likes_count,
				comments_count,
				shares_count,
				views_count,
				is_edited,
				is_deleted,
				created_at,
				updated_at
			FROM posts
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
				caption,
				media_url,
				thumbnail_url,
				media_type,
				location,
				likes_count,
				comments_count,
				shares_count,
				views_count,
				is_edited,
				is_deleted,
				created_at,
				updated_at
			FROM posts
			WHERE user_id = $1
			AND (created_at, id) < ($2, $3)
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

	var posts []models.Post

	for rows.Next() {

		var post models.Post

		err := rows.Scan(
			&post.ID,
			&post.UserID,
			&post.Caption,
			&post.MediaURL,
			&post.ThumbnailURL,
			&post.MediaType,
			&post.Location,
			&post.LikesCount,
			&post.CommentsCount,
			&post.SharesCount,
			&post.ViewsCount,
			&post.IsEdited,
			&post.IsDeleted,
			&post.CreatedAt,
			&post.UpdatedAt,
		)

		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": err.Error(),
			})
		}

		posts = append(posts, post)
	}

	var nextCursorTime string
	var nextCursorID string

	if len(posts) > 0 {

		last := posts[len(posts)-1]

		nextCursorTime = last.CreatedAt.Format(time.RFC3339)
		nextCursorID = last.ID
	}

	response := fiber.Map{

		"posts": posts,

		"next_cursor": fiber.Map{
			"cursor_time": nextCursorTime,
			"cursor_id":   nextCursorID,
		},

		"has_next": len(posts) == limit,
	}

	// Cache only first page
	if cursorTimeStr == "" {
		services.SetCache(cacheKey, response, 2*time.Minute)
	}

	return c.Status(fiber.StatusOK).JSON(response)
}
