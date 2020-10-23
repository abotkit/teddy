# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :teddy,
  ecto_repos: [Teddy.Repo]

# Configures the endpoint
config :teddy, TeddyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "E2B6sbQ1vuqIjo/pqRjz/4OXqEgR5gmYo0f4i3grVqhSG7+dAbZS1KAujHJZob5c",
  render_errors: [view: TeddyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Teddy.PubSub,
  live_view: [signing_salt: "AUOkja1h"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
