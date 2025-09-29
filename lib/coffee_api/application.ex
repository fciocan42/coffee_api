defmodule CoffeeApi.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the DataCache
      CoffeeApi.DataCache,
      # Start the Finch HTTP client
      {Finch, name: CoffeeApi.Finch},
      # Start the Endpoint (Web server)
      CoffeeApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: CoffeeApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
