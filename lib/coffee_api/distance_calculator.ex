defmodule CoffeeApi.DistanceCalculator do
  @moduledoc """
  Calculates the distance between two geographical points.
  """

  @earth_radius_km 6371

  @doc """
  Calculates the "great-circle" distance between two points on Earth.

  Accepts two `%Location{}` structs.
  Returns the distance in kilometers.
  """
  @spec calculate(CoffeeApi.Location.t(), CoffeeApi.Location.t()) :: float()
  def calculate(location1, location2) do
    # Convert degrees to radians
    lat1_rad = to_radians(location1.lat)
    lon1_rad = to_radians(location1.lon)
    lat2_rad = to_radians(location2.lat)
    lon2_rad = to_radians(location2.lon)

    dlon = lon2_rad - lon1_rad
    dlat = lat2_rad - lat1_rad

    a = :math.pow(:math.sin(dlat / 2), 2) + :math.cos(lat1_rad) * :math.cos(lat2_rad) * :math.pow(:math.sin(dlon / 2), 2)
    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))

    @earth_radius_km * c
  end

  @spec to_radians(number()) :: float()
  defp to_radians(degrees) do
    degrees * :math.pi() / 180
  end
end
