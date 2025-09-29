defmodule CoffeeApiWeb.HealthControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test
docker-compose run --rm app mix dialyzer
  import Mox

  alias CoffeeApi.DataCache

  setup :verify_on_exit!

  @opts CoffeeApiWeb.Endpoint.init([])

  test "GET /api/health returns 200 OK when cache is populated" do
    # Mock the DataCache to return a non-empty list
    expect(DataCache, :get_all, fn -> [%{}] end)

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
