# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :frontend, FrontendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+UZRlCmd1hmXYhq3ZvuHkg528lkPlwHe7NbFGAu4FbfV+UH2Gj12SkWqUbrZQIEB",
  render_errors: [view: FrontendWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Frontend.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kafka_ex,
  brokers: [
    {"kafka", 9092},
  ],
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  commit_interval: 5_000,
  commit_threshold: 100,
  kafka_version: "1.0.2"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
