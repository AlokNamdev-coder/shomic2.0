package handlers

import (
	"context"
	"shomic/database"
	"shomic/models"

	"github.com/gofiber/fiber/v2"
)

func AddLike(c *fiber.Ctx) error {

	postID := c.Params("postId")

	var request models.LikeRequest

	if err := c.BodyParser(&request); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid Request Body",
		})
	}

	tx, err := database.DB.Begin(context.Background())
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}
	defer tx.Rollback(context.Background())

	_, err = tx.Exec(
		context.Background(),

		`INSERT INTO likes(user_id, post_id)
		 VALUES($1,$2)`,

		request.UserID,
		postID,
	)

	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "User already liked this post",
		})
	}

	_, err = tx.Exec(
		context.Background(),

		`UPDATE posts
		 SET likes_count = likes_count + 1
		 WHERE id = $1`,

		postID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	err = tx.Commit(context.Background())

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Post liked successfully",
	})
}

func RemoveLike(c *fiber.Ctx) error {

	postID := c.Params("postId")

	var request models.LikeRequest

	if err := c.BodyParser(&request); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid Request Body",
		})
	}

	tx, err := database.DB.Begin(context.Background())
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}
	defer tx.Rollback(context.Background())

	commandTag, err := tx.Exec(
		context.Background(),

		`DELETE FROM likes
		 WHERE user_id = $1
		 AND post_id = $2`,

		request.UserID,
		postID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	if commandTag.RowsAffected() == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Like not found",
		})
	}

	_, err = tx.Exec(
		context.Background(),

		`UPDATE posts
		 SET likes_count = likes_count - 1
		 WHERE id = $1`,

		postID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	err = tx.Commit(context.Background())

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "Like removed successfully",
	})
}

func CheckLike(c *fiber.Ctx) error {

	postID := c.Params("postId")

	// Get the authenticated user's ID
	userID,ok := c.Locals("userID").(string)

	if !ok || userID == "" {
	return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
		"error": "Unauthorized",
	})
}

	var liked bool

	err := database.DB.QueryRow(
		context.Background(),

		`SELECT EXISTS(
			SELECT 1
			FROM likes
			WHERE user_id = $1
			AND post_id = $2
		)`,

		userID,
		postID,
	).Scan(&liked)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"liked": liked,
	})
}
