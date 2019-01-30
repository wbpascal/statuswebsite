# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :token_service, TokenServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EQrdgxBn770Hr0XCqwwqit8oVFWlLfQDXYNQ3j6u0y9ugWq7puR96PhB8plXSS1D",
  render_errors: [view: TokenServiceWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TokenService.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :token_service, jwt_secret: System.get_env("JWT_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
