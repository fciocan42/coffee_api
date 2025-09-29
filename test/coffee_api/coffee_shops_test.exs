defmodule CoffeeApi.CoffeeShopsTest do
  use ExUnit.Case, async: true

  import Mox

  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.CoffeeShops
  alias CoffeeApi.Location

  setup :verify_on_exit!

  describe "list_closest_coffee_shops/2" do
    test "returns the three closest coffee shops, sorted by distance and formatted" do
      # Mock data for DataCache
      mock_shops = [
        %CoffeeShop{name: "Starbucks Seattle", location: %Location{lat: 47.610378, lon: -122.342047}},
        %CoffeeShop{name: "Starbucks Seattle2", location: %Location{lat: 47.610378, lon: -122.342047}},
        %CoffeeShop{name: "Starbucks SF", location: %Location{lat: 37.7749, lon: -122.4194}},
        %CoffeeShop{name: "Distant Cafe", location: %Location{lat: 34.0522, lon: -118.2437}},
        %CoffeeShop{name: "Another Distant Cafe", location: %Location{lat: 50.0, lon: -100.0}}
      ]

      # Mock DataCache to return our predefined list of shops
      expect(CoffeeApi.DataCache, :get_all, fn -> mock_shops end)

      # User's coordinates (example from README: X=47.6, Y=-122.4)
      user_location = %Location{lat: 47.6, lon: -122.4}

      # Expected distances (approximate, based on DistanceCalculator)
      # Starbucks Seattle/Seattle2: ~0.02 km
      # Starbucks SF: ~1110.0 km
      # Distant Cafe: ~1500.0 km

      expected_response = [
        %{name: "Starbucks Seattle", location: {47.610378, -122.342047}, distance: 0.0200},
        %{name: "Starbucks Seattle2", location: {47.610378, -122.342047}, distance: 0.0200},
        %{name: "Starbucks SF", location: {37.7749, -122.4194}, distance: 1110.0000}
      ]

      result = CoffeeShops.list_closest_coffee_shops(user_location)

      assert length(result) == 3
      assert result == expected_response
    end

    test "returns fewer than three shops if not enough are available" do
      mock_shops = [
        %CoffeeShop{name: "Starbucks Seattle", location: %Location{lat: 47.610378, lon: -122.342047}}
      ]

      expect(CoffeeApi.DataCache, :get_all, fn -> mock_shops end)

      user_location = %Location{lat: 47.6, lon: -122.4}

      expected_response = [
        %{name: "Starbucks Seattle", location: {47.610378, -122.342047}, distance: 0.0200}
      ]

      result = CoffeeShops.list_closest_coffee_shops(user_location)

      assert length(result) == 1
      assert result == expected_response
    end

    test "returns an empty list if no coffee shops are available" do
      expect(CoffeeApi.DataCache, :get_all, fn -> [] end)

      user_location = %Location{lat: 47.6, lon: -122.4}

      result = CoffeeShops.list_closest_coffee_shops(user_location)

      assert result == []
    end
  end
end
