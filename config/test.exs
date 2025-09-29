import Config

config :coffee_api, CoffeeApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "RzVf0d+v4vA0hL8zR8zL9yY7vC6wX3bB2aA1nN9jK5gP1oO7sU3vD4wE2bA1nN9",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

config :coffee_api, finch: CoffeeApi.FinchMock

config :coffee_api, data_source: CoffeeApi.DataSourceMock
