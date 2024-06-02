defmodule FeedMe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FeedMeWeb.Telemetry,
      FeedMe.Repo,
      {DNSCluster, query: Application.get_env(:feed_me, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FeedMe.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FeedMe.Finch},
      # Start a worker by calling: FeedMe.Worker.start_link(arg)
      # {FeedMe.Worker, arg},
      # Start to serve requests, typically the last entry
      FeedMeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FeedMe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FeedMeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
