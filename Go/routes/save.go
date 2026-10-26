package routes

import (
	"shomic/handlers"

	"github.com/gofiber/fiber/v2"
)

func SaveRoutes(app *fiber.App) {
	app.Post("/posts/:id/save", handlers.CreateSave)
	app.Get("/users/:id/saved-posts", handlers.GetSaves)
	app.Delete("/posts/:id/save", handlers.DeleteSave)

}