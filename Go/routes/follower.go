package routes

import (
	"shomic/handlers"

	"github.com/gofiber/fiber/v2"
)

func FollowerRoutes(app *fiber.App) {
	app.Get("/users/:id/followers", handlers.GetFollowers)
	app.Get("/users/:id/following", handlers.GetFollowing)
	app.Post("/users/:id/follow", handlers.CreateFollower)
	app.Delete("/users/:id/unfollow",handlers.RemoveFollower)
}
