defmodule CoffeeApi.DataSourceTest do
  use ExUnit.Case, async: true

  import Mox

  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.DataSource

  @coffee_shops_url "https://static.reasig.ro/interview/coffee_shops_exerceise/coffee_shops.csv"

  setup :verify_on_exit!

  describe "fetch_coffee_shops/0" do
    test "when the request is successful, returns a list of valid coffee shops" do
      csv_body = """
      Name,X,Y
      Starbucks Seattle,47.610378,-122.342047
      Invalid Cafe,not_a_float,-122.5
      Incomplete Cafe,47.8

      """

      expect(CoffeeApi.FinchMock, :request, fn request, _transport_opts ->
        assert request.method == :get
        assert request.host == "static.reasig.ro"
        {:ok, %{status: 200, body: csv_body}}
      end)

      assert {:ok, [%CoffeeShop{} = shop]} = DataSource.fetch_coffee_shops()

      assert shop.name == "Starbucks Seattle"
      assert shop.location.lat == 47.610378
      assert shop.location.lon == -122.342047
    end

    test "when the request fails, returns an error tuple" do
      expect(CoffeeApi.FinchMock, :request, fn _, _ -> {:error, :econnrefused} end)

      assert {:error, :econnrefused} = DataSource.fetch_coffee_shops()
    end
  end
end
