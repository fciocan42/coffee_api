defmodule CoffeeApiWeb.CoffeeShopController do
  use CoffeeApiWeb, :controller

  alias CoffeeApi.CoffeeShops

  action_fallback CoffeeApiWeb.FallbackController

  def index(conn, %{"lat" => lat_str, "lon" => lon_str}) do
    with {:ok, lat} <- Float.parse(lat_str),
         {:ok, lon} <- Float.parse(lon_str) do
      coffee_shops = CoffeeShops.list_closest_coffee_shops(lat, lon)
      render(conn, :index, coffee_shops: coffee_shops)
    else
      _ ->
        {:error, :bad_request, "Invalid 'lat' or 'lon' parameters. Both must be valid numbers."}
    end
  end

  def index(conn, _params) do
    # This clause handles the case where 'lat' or 'lon' are missing.
    render(conn, :error, status: :bad_request, message: "Missing required 'lat' and 'lon' parameters.")
  end
end
