defmodule CoffeeApi.CoffeeShopsTest do
  use ExUnit.Case, async: true

  import Mox

  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.CoffeeShops

  setup :verify_on_exit!

  describe "list_closest_coffee_shops/2" do
    test "returns the three closest coffee shops, sorted by distance and formatted" do
      # Mock data for DataCache
      mock_shops = [
        %CoffeeShop{name: "Starbucks Seattle", x: 47.610378, y: -122.342047},
        %CoffeeShop{name: "Starbucks Seattle2", x: 47.610378, y: -122.342047}, # Same location as Seattle
        %CoffeeShop{name: "Starbucks SF", x: 37.7749, y: -122.4194},
        %CoffeeShop{name: "Distant Cafe", x: 34.0522, y: -118.2437}, # Los Angeles
        %CoffeeShop{name: "Another Distant Cafe", x: 50.0, y: -100.0}
      ]

      # Mock DataCache to return our predefined list of shops
      expect(CoffeeApi.DataCache, :get_all, fn -> mock_shops end)

      # User's coordinates (example from README: X=47.6, Y=-122.4)
      user_lat = 47.6
      user_lon = -122.4

      # Expected distances (approximate, based on DistanceCalculator)
      # Starbucks Seattle/Seattle2: ~0.02 km
      # Starbucks SF: ~1110.0 km
      # Distant Cafe: ~1500.0 km

      expected_response = [
        %{name: "Starbucks Seattle", location: {47.610378, -122.342047}, distance: 0.0200},
        %{name: "Starbucks Seattle2", location: {47.610378, -122.342047}, distance: 0.0200},
        %{name: "Starbucks SF", location: {37.7749, -122.4194}, distance: 1110.0000}
      ]

      result = CoffeeShops.list_closest_coffee_shops(user_lat, user_lon)

      assert length(result) == 3
      assert result == expected_response
    end

    test "returns fewer than three shops if not enough are available" do
      mock_shops = [
        %CoffeeShop{name: "Starbucks Seattle", x: 47.610378, y: -122.342047}
      ]

      expect(CoffeeApi.DataCache, :get_all, fn -> mock_shops end)

      user_lat = 47.6
      user_lon = -122.4

      expected_response = [
        %{name: "Starbucks Seattle", location: {47.610378, -122.342047}, distance: 0.0200}
      ]

      result = CoffeeShops.list_closest_coffee_shops(user_lat, user_lon)

      assert length(result) == 1
      assert result == expected_response
    end

    test "returns an empty list if no coffee shops are available" do
      expect(CoffeeApi.DataCache, :get_all, fn -> [] end)

      user_lat = 47.6
      user_lon = -122.4

      result = CoffeeShops.list_closest_coffee_shops(user_lat, user_lon)

      assert result == []
    end
  end
end
