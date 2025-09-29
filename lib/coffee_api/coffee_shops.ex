defmodule CoffeeApi.CoffeeShops do
  @moduledoc """
  The context for managing coffee shop-related business logic.
  """

  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.DataCache
  alias CoffeeApi.DistanceCalculator

  @doc """
  Lists the three closest coffee shops to the given coordinates.

  Returns a list of maps, each containing the coffee shop's name,
  location (latitude and longitude), and distance from the user,
  sorted from closest to farthest. Distances are rounded to 4 decimal places.
  """
  @spec list_closest_coffee_shops(float(), float()) :: [
          %{name: String.t(), location: {float(), float()}, distance: float()}
        ]
  def list_closest_coffee_shops(user_lat, user_lon) do
    DataCache.get_all()
    |> Enum.map(fn %CoffeeShop{name: name, x: x, y: y} ->
      distance = DistanceCalculator.calculate({user_lat, user_lon}, {x, y})
      %{name: name, x: x, y: y, distance: distance}
    end)
    |> Enum.sort_by(& &1.distance)
    |> Enum.take(3)
    |> Enum.map(&format_coffee_shop/1)
  end

  defp format_coffee_shop(%{name: name, x: x, y: y, distance: distance}) do
    %{
      name: name,
      location: {x, y},
      distance: round_float(distance, 4)
    }
  end

  defp round_float(float, precision) do
    :erlang.float_to_binary(float, decimals: precision) |> String.to_float()
  end
end
