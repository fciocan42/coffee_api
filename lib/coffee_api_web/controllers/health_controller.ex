defmodule CoffeeApiWeb.HealthController do
  use CoffeeApiWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
