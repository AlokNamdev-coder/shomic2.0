package routes

import (
	"shomic/handlers"

	"github.com/gofiber/fiber/v2"
)

func LikeRoutes(app *fiber.App) {
	app.Post("/posts/:postId/like", handlers.AddLike)
	app.Delete("/posts/:postId/like", handlers.RemoveLike)
	app.Get("/posts/:postId/like", handlers.CheckLike)

}