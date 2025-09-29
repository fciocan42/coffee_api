import Config

# Note: The secret key base is used to sign/encrypt cookies and other secrets.
# A random value is generated for development, but for production it should
# be set properly as a long and random string.
# You can generate one with `mix phx.gen.secret`.
secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :coffee_api, CoffeeApiWeb.Endpoint,
  url: [host: "localhost", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: secret_key_base

# Do not print debug messages in production
config :logger, level: :info

# Configure the data source to use the real implementation in production
config :coffee_api, data_source: CoffeeApi.DataSource
