package handlers

import (
	"context"
	"shomic/database"
	"shomic/models"
	"shomic/services"
	"time"

	"github.com/gofiber/fiber/v2"
)

func GetFollowers(c *fiber.Ctx) error {

	followingID := c.Params("id")

	limit := c.QueryInt("limit", 20)

	cursorTimeStr := c.Query("cursor_time")
	cursorFollowerID := c.Query("cursor_follower_id")

	cacheKey:="followers:"+followingID

	if (cursorTimeStr == "") != (cursorFollowerID == "") {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cursor_time and cursor_follower_id must be provided together",
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
				follower_id,
				following_id,
				created_at
			FROM followers
			WHERE following_id = $1
			ORDER BY created_at DESC, follower_id DESC
			LIMIT $2`,

			followingID,
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
				follower_id,
				following_id,
				created_at
			FROM followers
			WHERE following_id = $1
			AND (created_at, follower_id) < ($2, $3)
			ORDER BY created_at DESC, follower_id DESC
			LIMIT $4`,

			followingID,
			cursorTime,
			cursorFollowerID,
			limit,
		)
	}

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	defer rows.Close()

	var followers []models.Follower

	for rows.Next() {

		var follower models.Follower

		err := rows.Scan(
			&follower.FollowerID,
			&follower.FollowingID,
			&follower.CreatedAt,
		)

		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": err.Error(),
			})
		}

		followers = append(followers, follower)
	}

	var nextCursorTime string
	var nextCursorFollowerID string

	if len(followers) > 0 {

		last := followers[len(followers)-1]

		nextCursorTime = last.CreatedAt.Format(time.RFC3339)
		nextCursorFollowerID = last.FollowerID
	}

	response:=fiber.Map{
		"followers": followers,

		"next_cursor": fiber.Map{
			"cursor_time":        nextCursorTime,
			"cursor_follower_id": nextCursorFollowerID,
		},

		"has_next": len(followers) == limit,
	}

	if cursorTimeStr==""{
		services.SetCache(cacheKey,response,5*time.Minute)
	}

	return c.Status(fiber.StatusOK).JSON(response)
}

func CreateFollower(c *fiber.Ctx) error {

	followingID := c.Params("id")

	var request models.FollowRequest

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

		`INSERT INTO followers
		(
			follower_id,
			following_id
		)
		VALUES
		(
			$1,$2
		)`,

		request.FollowerID,
		followingID,
	)

	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	_, err = tx.Exec(
		context.Background(),

		`UPDATE users
		 SET followers_count = followers_count + 1
		 WHERE id = $1`,

		followingID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	_, err = tx.Exec(
		context.Background(),

		`UPDATE users
		 SET following_count = following_count + 1
		 WHERE id = $1`,

		request.FollowerID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	if err = tx.Commit(context.Background()); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "User followed successfully",
	})
}

func RemoveFollower(c *fiber.Ctx) error {

	followingID := c.Params("id")

	var request models.FollowRequest

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

		`DELETE FROM followers
		 WHERE follower_id = $1
		 AND following_id = $2`,

		request.FollowerID,
		followingID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	if commandTag.RowsAffected() == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Follow relationship not found",
		})
	}

	_, err = tx.Exec(
		context.Background(),

		`UPDATE users
		 SET followers_count = followers_count - 1
		 WHERE id = $1`,

		followingID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	_, err = tx.Exec(
		context.Background(),

		`UPDATE users
		 SET following_count = following_count - 1
		 WHERE id = $1`,

		request.FollowerID,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	if err = tx.Commit(context.Background()); err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "User unfollowed successfully",
	})
}

func GetFollowing(c *fiber.Ctx) error {

	followerID := c.Params("id")

	limit := c.QueryInt("limit", 20)

	cursorTimeStr := c.Query("cursor_time")
	cursorFollowingID := c.Query("cursor_following_id")

	cacheKey := "followings:"+followerID

	if (cursorTimeStr == "") != (cursorFollowingID == "") {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "cursor_time and cursor_following_id must be provided together",
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
				follower_id,
				following_id,
				created_at
			FROM followers
			WHERE follower_id = $1
			ORDER BY created_at DESC, following_id DESC
			LIMIT $2`,

			followerID,
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
				follower_id,
				following_id,
				created_at
			FROM followers
			WHERE follower_id = $1
			AND (created_at, following_id) < ($2, $3)
			ORDER BY created_at DESC, following_id DESC
			LIMIT $4`,

			followerID,
			cursorTime,
			cursorFollowingID,
			limit,
		)
	}

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	defer rows.Close()

	var following []models.Follower

	for rows.Next() {

		var follow models.Follower

		err := rows.Scan(
			&follow.FollowerID,
			&follow.FollowingID,
			&follow.CreatedAt,
		)

		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": err.Error(),
			})
		}

		following = append(following, follow)
	}

	var nextCursorTime string
	var nextCursorFollowingID string

	if len(following) > 0 {

		last := following[len(following)-1]

		nextCursorTime = last.CreatedAt.Format(time.RFC3339)
		nextCursorFollowingID = last.FollowingID
	}

	response:=fiber.Map{
		"following": following,

		"next_cursor": fiber.Map{
			"cursor_time":             nextCursorTime,
			"cursor_following_id":     nextCursorFollowingID,
		},

		"has_next": len(following) == limit,
	}

	if cursorTimeStr==""{
		services.SetCache(cacheKey,response,5*time.Minute)
	}

	return c.Status(fiber.StatusOK).JSON(response)
}
