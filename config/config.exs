import Config

config :coffee_api, CoffeeApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: CoffeeApiWeb.ErrorJSON],
    layout: false
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
