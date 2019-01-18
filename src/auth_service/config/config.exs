# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :auth_service,
  ecto_repos: [AuthService.Repo]

# Configures the endpoint
config :auth_service, AuthServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kr6gqAzANw9m4UKg2dFyJwnWTzlS/M4P8F7CLKgMpiI2mldt6P49ywjtEs+1B22O",
  render_errors: [view: AuthServiceWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: AuthService.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :mariaex, json_library: Jason

config :tesla, adapter: Tesla.Adapter.Hackney

# Configure the database
config :auth_service, AuthService.Repo,
  username: "root",
  password: System.get_env("MYSQL_PASS"),
  database: "auth_service",
  hostname: "mariadb",
  port: 3306

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
