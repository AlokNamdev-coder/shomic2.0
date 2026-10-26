package handlers

import (
	"context"
	"shomic/database"
	"shomic/models"
	"shomic/services"
	"time"

	"github.com/gofiber/fiber/v2"
)

func CreateSave(c *fiber.Ctx) error {

	postID := c.Params("id")

	// cacheKey:="saves:"+postID

	var save models.Save

	if err := c.BodyParser(&save); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid Request Body",
		})
	}

	_, err := database.DB.Exec(
		context.Background(),

		`INSERT INTO saves
		(
			user_id,
			post_id
		)
		VALUES
		(
			$1,$2
		)`,

		save.UserID,
		postID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	// if services.CacheExist(cacheKey){
	// 	services.DeleteCache(cacheKey)
	// }

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Post saved successfully",
	})
}

func GetSaves(c *fiber.Ctx) error {

	userID := c.Params("id")

	limit := c.QueryInt("limit", 20)

	cursorTimeStr := c.Query("cursor_time")
	cursorPostID := c.Query("cursor_post_id")

	if (cursorTimeStr == "") != (cursorPostID == "") {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cursor_time and cursor_post_id must be provided together",
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

		var CachedResponse fiber.Map

		if services.CacheExist("saves:"+userID){
			services.GetCache("saves:"+userID,&CachedResponse)

			return c.Status(fiber.StatusOK).JSON(CachedResponse)
		}

		rows, err = database.DB.Query(
			context.Background(),

			`SELECT

				posts.id,
				posts.user_id,
				posts.caption,
				posts.media_url,
				posts.thumbnail_url,
				posts.media_type,
				posts.location,

				posts.likes_count,
				posts.comments_count,
				posts.shares_count,
				posts.views_count,

				posts.is_edited,
				posts.is_deleted,

				posts.created_at,
				posts.updated_at,

				saves.created_at

			FROM saves

			INNER JOIN posts

			ON saves.post_id = posts.id

			WHERE saves.user_id = $1

			ORDER BY saves.created_at DESC,
					 posts.id DESC

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

				posts.id,
				posts.user_id,
				posts.caption,
				posts.media_url,
				posts.thumbnail_url,
				posts.media_type,
				posts.location,

				posts.likes_count,
				posts.comments_count,
				posts.shares_count,
				posts.views_count,

				posts.is_edited,
				posts.is_deleted,

				posts.created_at,
				posts.updated_at,

				saves.created_at

			FROM saves

			INNER JOIN posts

			ON saves.post_id = posts.id

			WHERE saves.user_id = $1

			AND (saves.created_at, posts.id) < ($2,$3)

			ORDER BY saves.created_at DESC,
					 posts.id DESC

			LIMIT $4`,

			userID,
			cursorTime,
			cursorPostID,
			limit,
		)
	}

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	defer rows.Close()

	var savedPosts []models.SavedPost

	for rows.Next() {

		var item models.SavedPost

		err := rows.Scan(

			&item.Post.ID,
			&item.Post.UserID,
			&item.Post.Caption,
			&item.Post.MediaURL,
			&item.Post.ThumbnailURL,
			&item.Post.MediaType,
			&item.Post.Location,

			&item.Post.LikesCount,
			&item.Post.CommentsCount,
			&item.Post.SharesCount,
			&item.Post.ViewsCount,

			&item.Post.IsEdited,
			&item.Post.IsDeleted,

			&item.Post.CreatedAt,
			&item.Post.UpdatedAt,

			&item.SavedAt,
		)

		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": err.Error(),
			})
		}

		savedPosts = append(savedPosts, item)
	}

	var nextCursorTime string
	var nextCursorPostID string

	if len(savedPosts) > 0 {

		last := savedPosts[len(savedPosts)-1]

		nextCursorTime = last.SavedAt.Format(time.RFC3339)
		nextCursorPostID = last.Post.ID
	}

	

	response := fiber.Map{

		"saved_posts": savedPosts,

		"next_cursor": fiber.Map{
			"cursor_time": nextCursorTime,
			"cursor_post_id": nextCursorPostID,
		},

		"has_next": len(savedPosts) == limit,
	}

	if cursorTimeStr ==""{
		services.SetCache("saves:"+userID,response,2*time.Minute)
	}

	return c.Status(fiber.StatusOK).JSON(response)
}

func DeleteSave(c *fiber.Ctx) error {

	postID := c.Params("id")
	

	var save models.Save

	if err := c.BodyParser(&save); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid Request Body",
		})
	}

	commandTag, err := database.DB.Exec(
		context.Background(),

		`DELETE FROM saves
		 WHERE user_id = $1
		 AND post_id = $2`,

		save.UserID,
		postID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	if commandTag.RowsAffected() == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Save not found",
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Post removed from saved posts",
	})
}
