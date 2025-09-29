defmodule CoffeeApi.DataCacheTest do
  use ExUnit.Case, async: true

  import Mox

  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.DataCache
  alias CoffeeApi.Location

  setup :verify_on_exit!

  describe "DataCache GenServer" do
    test "on init, it fetches and caches the coffee shops" do
      # 1. Define some mock coffee shops that we expect our cache to hold.
      mock_coffee_shops = [%CoffeeShop{name: "Test Cafe", location: %Location{lat: 1.0, lon: 1.0}}]

      # 2. Expect the DataSource to be called and return our mock data.
      # This mock is defined in `test/test_helper.exs`.
      expect(CoffeeApi.DataSourceMock, :fetch_coffee_shops, fn ->
        {:ok, mock_coffee_shops}
      end)

      # 3. Start the DataCache. This will trigger its init/1 callback.
      start_supervised!({DataCache, []})

      # 4. Assert that the cache now holds the mock data.
      assert DataCache.get_all() == mock_coffee_shops
    end

    test "when DataSource fails, it starts with an empty list" do
      # Expect the DataSource to be called and return an error.
      expect(CoffeeApi.DataSourceMock, :fetch_coffee_shops, fn ->
        {:error, :network_failure}
      end)

      # Start the cache.
      start_supervised!({DataCache, []})

      # Assert the cache is empty.
      assert DataCache.get_all() == []
    end
  end
end
