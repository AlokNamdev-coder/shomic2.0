package middleware

import (
	"context"
	"strings"

	"shomic/firebase"

	"github.com/gofiber/fiber/v2"
)

func FirebaseAuth(c *fiber.Ctx) error {

	header := c.Get("Authorization")

	if header == "" {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": "Missing Authorization header",
		})
	}

	token := strings.TrimPrefix(header, "Bearer ")

	authClient, err := firebase.App.Auth(context.Background())
	if err != nil {
		return err
	}

	decodedToken, err := authClient.VerifyIDToken(context.Background(), token)
	if err != nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": "Invalid token",
		})
	}

	c.Locals("userID", decodedToken.UID)

	return c.Next()
}