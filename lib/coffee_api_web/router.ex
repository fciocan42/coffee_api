defmodule CoffeeApiWeb.Router do
  use CoffeeApiWeb, :router
  use PhoenixSwagger

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CoffeeApiWeb do
    pipe_through :api
    get "/health", HealthController, :index
    get "/coffee_shops", CoffeeShopController, :index
  end

  scope "/api" do
    forward "/swagger", PhoenixSwagger.Plug.Swagger,
      swagger_file: "swagger.json",
      router: __MODULE__,
      endpoint: CoffeeApiWeb.Endpoint
  end
end
