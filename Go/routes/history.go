package routes

import (
	"shomic/handlers"

	"github.com/gofiber/fiber/v2"
)

func HistoryRoutes(app *fiber.App) {

	app.Post("/search/history", handlers.CreateSearchHistory)
	app.Get("/users/:id/search-history", handlers.GetSearchHistory)
	app.Get("/search/users",)

}