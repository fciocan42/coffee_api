defmodule CoffeeApiWeb.Router do
  use CoffeeApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoffeeApiWeb do
    pipe_through :api
    get "/health", HealthController, :index
    get "/coffee_shops", CoffeeShopController, :index
  end
end
