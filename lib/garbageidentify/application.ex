defmodule Garbageidentify.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GarbageidentifyWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:garbageidentify, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Garbageidentify.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Garbageidentify.Finch},
      # Start a worker by calling: Garbageidentify.Worker.start_link(arg)
      # {Garbageidentify.Worker, arg},
      # Start to serve requests, typically the last entry
      GarbageidentifyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Garbageidentify.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GarbageidentifyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
