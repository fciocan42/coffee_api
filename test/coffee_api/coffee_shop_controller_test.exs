defmodule CoffeeApiWeb.CoffeeShopControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias CoffeeApi.CoffeeShops
  alias CoffeeApi.Location
  import Mox

  setup :verify_on_exit!

  @opts CoffeeApiWeb.Endpoint.init([])

  test "GET /api/coffee_shops with valid params returns 200 OK" do
    # We don't need to test the context logic again, just that it's called.
    # We can return a simple mock response.
    expect(CoffeeApi.CoffeeShops, :list_closest_coffee_shops, fn %Location{lat: 47.6, lon: -122.4} ->
      [%{name: "Test Cafe"}]
    end)

    conn = conn(:get, "/api/coffee_shops?lat=47.6&lon=-122.4")
    conn = CoffeeApiWeb.Endpoint.call(conn, @opts)

    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"data" => [%{"name" => "Test Cafe"}]}
  end

  test "GET /api/coffee_shops with missing params returns 400 Bad Request" do
    conn = conn(:get, "/api/coffee_shops?lat=47.6") # Missing 'lon'
    conn = CoffeeApiWeb.Endpoint.call(conn, @opts)

    assert conn.status == 400
    assert Jason.decode!(conn.resp_body) == %{"error" => "Missing required 'lat' and 'lon' parameters."}
  end

  test "GET /api/coffee_shops with invalid params returns 400 Bad Request" do
    conn = conn(:get, "/api/coffee_shops?lat=not_a_number&lon=-122.4")
    conn = CoffeeApiWeb.Endpoint.call(conn, @opts)

    assert conn.status == 400
    assert Jason.decode!(conn.resp_body)["error"] |> String.contains?("Invalid 'lat' or 'lon' parameters")
  end
end
