defmodule CoffeeApiWeb.HealthController do
  use CoffeeApiWeb, :controller

  alias CoffeeApi.DataCache

  def index(conn, _params) do
    case DataCache.get_all() do
      [] ->
        conn
        |> put_status(:service_unavailable)
        |> render(:degraded, reason: "Data cache is not populated")
      [_ | _] ->
        render(conn, :index)
    end
  end
end
