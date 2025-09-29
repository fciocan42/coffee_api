import Config

# Configure the Phoenix endpoint
config :coffee_api, CoffeeApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: CoffeeApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: CoffeeApi.PubSub,
  live_view: [signing_salt: "another salt"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
