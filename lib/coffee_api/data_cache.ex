defmodule CoffeeApi.DataCache do
  @moduledoc """
  A GenServer that caches the list of coffee shops in memory.
  """
  use GenServer
  require Logger

  alias CoffeeApi.CoffeeShop

  # Client API

  @doc "Starts the DataCache GenServer."
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc "Returns the cached list of coffee shops."
  @spec get_all() :: [CoffeeShop.t()]
  def get_all() do
    GenServer.call(__MODULE__, :get_all)
  end

  # Server Callbacks

  @impl true
  def init(_opts) do
    # Fetch the data source module from the application config.
    # This allows us to use a mock in the test environment.
    data_source = Application.fetch_env!(:coffee_api, :data_source)

    case data_source.fetch_coffee_shops() do
      {:ok, coffee_shops} ->
        {:ok, coffee_shops}
      {:error, reason} ->
        Logger.error(fn -> "DataCache failed to load coffee shops: #{inspect(reason)}" end)
        {:ok, []}
    end
  end

  @impl true
  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end
end
