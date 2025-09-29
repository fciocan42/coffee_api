defmodule CoffeeApi.CoffeeShop do
  @moduledoc """
  An Entity representing a single coffee shop.
  It also holds a calculated distance, which is populated on-demand.
  """

  alias CoffeeApi.Location

  @enforce_keys [:name, :location]
  defstruct [:name, :location, :distance]

  @type t :: %__MODULE__{
          name: String.t(),
          location: Location.t(),
          distance: float() | nil
        }
end
