package routes

import (
	"shomic/handlers"

	"github.com/gofiber/fiber/v2"
)

func UserRoutes(app *fiber.App) {

	app.Post("/users", handlers.PostUsers)

	app.Get("/users/:id", handlers.GetUser)

	app.Put("/users/:id/:field", handlers.UpdateUser)

	app.Delete("/users/:id", handlers.DeleteUser)
}
