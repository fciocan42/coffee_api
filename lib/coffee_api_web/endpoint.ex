defmodule CoffeeApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :coffee_api

  @session_options [
    store: :cookie,
    key: "_coffee_api_key",
    signing_salt: "some salt",
    same_site: "Lax"
  ]

  plug Plug.RequestId
  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Phoenix.json_library()
  plug Plug.Router, __MODULE__.Router
end
