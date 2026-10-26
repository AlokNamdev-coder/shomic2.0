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

type UpdateField struct {
	Value interface{} `json:"value"`
}

func PostUsers(c *fiber.Ctx) error {

	var user models.User

	err := c.BodyParser(&user)

	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid Request Body",
		})
	}

	fmt.Printf("DB Address in Handler is %p", &database.DB)

	fmt.Printf("DB Address in Handler is %p", database.DB)

	_, error := database.DB.Exec(
		context.Background(),
		`INSERT INTO users
		(
			id,
			username,
			email,
			password_hash,
			full_name,
			bio,
			phone,
			country,
			city,
			birth_date,
			profile_picture_url,
			cover_picture_url,
			gender,
			is_verified,
			is_private,
			followers_count,
			following_count,
			posts_count,
			created_at,
			updated_at
		)

		VALUES
		(
			$1,$2,$3,$4,$5,
			$6,$7,$8,$9,$10,
			$11,$12,$13,$14,$15,
			$16,$17,$18,$19,$20
		)`,

		user.ID,
		user.Username,
		user.Email,
		user.PasswordHash,
		user.FullName,
		user.Bio,
		user.Phone,
		user.Country,
		user.City,
		user.BirthDate,
		user.ProfilePictureURL,
		user.CoverPictureURL,
		user.Gender,
		user.IsVerified,
		user.IsPrivate,
		user.FollowersCount,
		user.FollowingCount,
		user.PostsCount,
		user.CreatedAt,
		user.UpdatedAt,
	)

	if error != nil {
		return c.JSON(fiber.Map{
			"error": error.Error(),
		})
	}

	return c.Status(fiber.StatusCreated).JSON(fiber.Map{
		"message": "Successfully Created The User",
	})

}

func GetUser(c *fiber.Ctx) error {

	id := c.Params("id")

	var user models.User

	if services.CacheExist("user:"+id){
		services.GetCache("user:"+id,&user)

		return c.Status(fiber.StatusOK).JSON(user)
	}

	err := database.DB.QueryRow(
		context.Background(),
		`SELECT
			id,
			username,
			email,
			password_hash,
			full_name,
			bio,
			phone,
			country,
			city,
			birth_date,
			profile_picture_url,
			cover_picture_url,
			gender,
			is_verified,
			is_private,
			followers_count,
			following_count,
			posts_count,
			created_at,
			updated_at
		FROM users
		WHERE id = $1`,
		id,
	).Scan(
		&user.ID,
		&user.Username,
		&user.Email,
		&user.PasswordHash,
		&user.FullName,
		&user.Bio,
		&user.Phone,
		&user.Country,
		&user.City,
		&user.BirthDate,
		&user.ProfilePictureURL,
		&user.CoverPictureURL,
		&user.Gender,
		&user.IsVerified,
		&user.IsPrivate,
		&user.FollowersCount,
		&user.FollowingCount,
		&user.PostsCount,
		&user.CreatedAt,
		&user.UpdatedAt,
	)

	

	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "User not found",
		})
	}

	services.SetCache("user:"+id,user,10*time.Minute)

	return c.Status(fiber.StatusOK).JSON(user)
}

func UpdateUser(c *fiber.Ctx) error {

	id := c.Params("id")
	field := c.Params("field")

	cacheKey:="user:"+id

	allowedFields := map[string]bool{
		"username":             true,
		"full_name":            true,
		"bio":                  true,
		"phone":                true,
		"country":              true,
		"city":                 true,
		"birth_date":           true,
		"profile_picture_url":  true,
		"cover_picture_url":    true,
		"gender":               true,
		"is_private":           true,
	}

	if !allowedFields[field] {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid field name",
		})
	}

	var body UpdateField

	if err := c.BodyParser(&body); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Invalid request body",
		})
	}

	query := fmt.Sprintf(
		"UPDATE users SET %s = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2",
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
			"error": "User not found",
		})
	}

	if services.CacheExist(cacheKey){
		services.DeleteCache(cacheKey)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": fmt.Sprintf("%s updated successfully", field),
	})
}

func DeleteUser(c *fiber.Ctx) error {

	id := c.Params("id")

	cacheKey:="user"+id

	commandTag, err := database.DB.Exec(
		context.Background(),
		"DELETE FROM users WHERE id = $1",
		id,
	)

	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	if commandTag.RowsAffected() == 0 {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "User not found",
		})
	}

	if services.CacheExist(cacheKey){
		services.DeleteCache(cacheKey)
	}

	return c.Status(fiber.StatusOK).JSON(fiber.Map{
		"message": "User deleted successfully",
	})
}
