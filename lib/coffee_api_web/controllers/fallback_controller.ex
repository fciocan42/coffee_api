defmodule CoffeeApiWeb.FallbackController do
  use CoffeeApiWeb, :controller

  def call(conn, {:error, :bad_request, message}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: CoffeeApiWeb.CoffeeShopJSON)
    |> render(:error, message: message)
  end
end
