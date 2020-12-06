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
  secret_key_base: "hXXqOt7GgW0mVZrMUfNlHlaRODjoaIiD//lcCtBjKPBLpPqXzrBQz9ctNEs2EdIw",
  render_errors: [view: TeddyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Teddy.PubSub,
  live_view: [signing_salt: "XVe0ntrR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :crawly,
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:name]},
    {Crawly.Pipelines.DuplicatesFilter, item_id: :name},
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, folder: "./crawls/", extension: "jl"}
  ],
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    # Crawly.Middlewares.RobotsTxt,
    {Crawly.Middlewares.UserAgent, user_agents: ["Abotkit Crawler"]},
    {Crawly.Middlewares.RequestOptions, [timeout: 30_000, recv_timeout: 15000]}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
