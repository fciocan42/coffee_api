defmodule CoffeeApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :coffee_api

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_coffee_api_key",
    signing_salt: "some salt",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :coffee_api,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  plug Plug.RequestId
  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Phoenix.json_library()
  plug Plug.Router, __MODULE__.Router
end
