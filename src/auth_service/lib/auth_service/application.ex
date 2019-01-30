defmodule AuthService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # Mix.Tasks.Ecto.Create.run([])
    # Mix.Tasks.Ecto.Migrate.run([])
    # Mix.Tasks.Run.run("priv/repo/seeds.exs")

    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      AuthService.Repo,
      # Start the endpoint when the application starts
      AuthServiceWeb.Endpoint
      # Starts a worker by calling: AuthService.Worker.start_link(arg)
      # {AuthService.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthService.Supervisor]
    result = Supervisor.start_link(children, opts)

    # Seed the database
    AuthService.DatabaseSeeder.seed()

    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AuthServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
