defmodule Teddy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Teddy.Repo,
      # Start the Telemetry supervisor
      TeddyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Teddy.PubSub},
      # Start the Endpoint (http/https)
      TeddyWeb.Endpoint
      # Start a worker by calling: Teddy.Worker.start_link(arg)
      # {Teddy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Teddy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TeddyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
