defmodule CoffeeApiWeb.HealthControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Mox

  alias CoffeeApi.DataCache
  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.Location

  setup :verify_on_exit!

  @opts CoffeeApiWeb.Endpoint.init([])

  test "GET /api/health returns 200 OK when cache is populated" do
    # Mock the DataCache to return a non-empty list of CoffeeShops
    expect(DataCache, :get_all, fn -> [%CoffeeShop{name: "Test", location: %Location{lat: 1.0, lon: 1.0}}] end)

    conn = conn(:get, "/api/health")
    conn = CoffeeApiWeb.Endpoint.call(conn, @opts)

    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"status" => "ok"}
  end

  test "GET /api/health returns 503 Service Unavailable when cache is empty" do
    # Mock the DataCache to return an empty list
    expect(DataCache, :get_all, fn -> [] end)

    conn = conn(:get, "/api/health")
    conn = CoffeeApiWeb.Endpoint.call(conn, @opts)

    assert conn.status == 503
    assert Jason.decode!(conn.resp_body) == %{"status" => "degraded", "reason" => "Data cache is not populated"}
  end
end
