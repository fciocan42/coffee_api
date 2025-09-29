defmodule CoffeeApi.DistanceCalculatorTest do
  use ExUnit.Case, async: true

  alias CoffeeApi.DistanceCalculator
  alias CoffeeApi.Location

  describe "calculate/2" do
    test "calculates the distance between two points correctly" do
      # Coordinates for San Francisco and Los Angeles
      sf_location = %Location{lat: 37.7749, lon: -122.4194}
      la_location = %Location{lat: 34.0522, lon: -118.2437}

      # The approximate distance is ~559 km. We use `assert_in_delta`
      # to account for minor floating-point inaccuracies.
      expected_distance_km = 559.1

      assert_in_delta DistanceCalculator.calculate(sf_location, la_location), expected_distance_km, 0.1
    end

    test "returns 0 when the coordinates are identical" do
      # Coordinates for New York City
      nyc_location = %Location{lat: 40.7128, lon: -74.0060}

      assert DistanceCalculator.calculate(nyc_location, nyc_location) == 0.0
    end

    test "calculates distance across the equator" do
      # Point in Colombia (north) to a point in Peru (south)
      point_north = %Location{lat: 4.7110, lon: -74.0721} # Bogotá
      point_south = %Location{lat: -12.0464, lon: -77.0428} # Lima
      expected_distance_km = 1883.5

      assert_in_delta DistanceCalculator.calculate(point_north, point_south), expected_distance_km, 1.0
    end
  end
end
