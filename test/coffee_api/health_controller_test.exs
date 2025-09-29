defmodule CoffeeApiWeb.HealthControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts CoffeeApiWeb.Endpoint.init([])

  test "GET /api/health returns 200 OK" do
    conn = conn(:get, "/api/health")
    conn = CoffeeApiWeb.Endpoint.call(conn, @opts)

    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == %{"status" => "ok"}
  end
end
