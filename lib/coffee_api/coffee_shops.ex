defmodule CoffeeApi.CoffeeShops do
  @moduledoc """
  The context for managing coffee shop-related business logic.
  """

  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.DataCache
  alias CoffeeApi.DistanceCalculator
  alias CoffeeApi.Location

  @doc """
  Lists the three closest coffee shops to the given coordinates.

  Returns a list of maps, each containing the coffee shop's name,
  location (latitude and longitude), and distance from the user,
  sorted from closest to farthest. Distances are rounded to 4 decimal places.
  """
  @spec list_closest_coffee_shops(Location.t()) :: [
          %{name: String.t(), location: {float(), float()}, distance: float()}
        ]
  def list_closest_coffee_shops(user_location) do
    DataCache.get_all()
    |> Enum.map(fn %CoffeeShop{name: name, location: shop_location} ->
      distance = DistanceCalculator.calculate(user_location, shop_location)
      %{name: name, location: shop_location, distance: distance}
    end)
    |> Enum.sort_by(& &1.distance)
    |> Enum.take(3)
    |> Enum.map(&format_coffee_shop/1)
  end

  defp format_coffee_shop(%{name: name, location: %Location{lat: lat, lon: lon}, distance: distance}) do
    %{
      name: name,
      location: {lat, lon},
      distance: round_float(distance, 4)
    }
  end

  defp round_float(float, precision) do
    :erlang.float_to_binary(float, decimals: precision) |> String.to_float()
  end
end
