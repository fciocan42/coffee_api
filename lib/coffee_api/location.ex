defmodule CoffeeApi.Location do
  @moduledoc """
  A Value Object representing a geographical location.
  """

  @enforce_keys [:lat, :lon]
  defstruct [:lat, :lon]

  @type t :: %__MODULE__{
          lat: float(),
          lon: float()
        }
end
