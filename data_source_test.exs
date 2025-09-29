defmodule CoffeeApi.DataSourceTest do
  use ExUnit.Case, async: true

  import Mox

  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.DataSource

  # The URL we expect the DataSource to fetch.
  @coffee_shops_url "https://static.reasig.ro/interview/coffee_shops_exerceise/coffee_shops.csv"

  setup :verify_on_exit!

  describe "fetch_coffee_shops/0" do
    test "when the request is successful, returns a list of valid coffee shops" do
      # This CSV body contains a header, a valid row, and several malformed rows.
      csv_body = """
      Name,X,Y
      Starbucks Seattle,47.610378,-122.342047
      Invalid Cafe,not_a_float,-122.5
      Incomplete Cafe,47.8

      """

      # We expect Finch to be called and we tell Mox to return our sample CSV body.
      expect(CoffeeApi.FinchMock, :request, fn request, _transport_opts ->
        assert request.method == :get
        assert request.host == "static.reasig.ro"
        {:ok, %{status: 200, body: csv_body}}
      end)

      # We call the function we are testing.
      assert {:ok, [%CoffeeShop{} = shop]} = DataSource.fetch_coffee_shops()

      # We assert that only the valid row was parsed correctly.
      assert shop.name == "Starbucks Seattle"
      assert shop.x == 47.610378
      assert shop.y == -122.342047
    end

    test "when the request fails, returns an error tuple" do
      # We tell Mox to simulate a network error.
      expect(CoffeeApi.FinchMock, :request, fn _, _ -> {:error, :econnrefused} end)

      assert {:error, :econnrefused} = DataSource.fetch_coffee_shops()
    end
  end
end