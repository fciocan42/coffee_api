defmodule CoffeeApi.DataSource do
  @moduledoc """
  Handles fetching and parsing of coffee shop data from the remote CSV source.
  """

  alias CoffeeApi.CoffeeShop
  alias CoffeeApi.Location

  @coffee_shops_url "https://static.reasig.ro/interview/coffee_shops_exerceise/coffee_shops.csv"

  @doc """
  Fetches and parses the coffee shop data.

  Returns `{:ok, [list_of_coffee_shops]}` on success,
  or `{:error, reason}` on failure.
  """
  @spec fetch_coffee_shops() :: {:ok, [CoffeeShop.t()]} | {:error, any()}
  def fetch_coffee_shops do
    request = Finch.build(:get, @coffee_shops_url)

    with {:ok, %{status: 200, body: body}} <- Finch.request(request, CoffeeApi.Finch),
         {:ok, coffee_shops} <- parse_csv(body) do
      {:ok, coffee_shops}
    else
      {:ok, %{status: status}} -> {:error, {:bad_status, status}}
      {:error, reason} -> {:error, reason}
    end
  end

  defp parse_csv(csv_body) do
    coffee_shops =
      csv_body
      |> NimbleCSV.parse_string(skip_headers: true)
      |> Enum.filter_map(&row_to_coffee_shop/1)

    {:ok, coffee_shops}
  end

  defp row_to_coffee_shop([name, x_str, y_str]) do
    with {:ok, x} <- Float.parse(x_str),
         {:ok, y} <- Float.parse(y_str) do
      %CoffeeShop{name: name, location: %Location{lat: x, lon: y}}
    else
      _ -> nil # If parsing fails, return nil to be filtered out by Enum.filter_map/2
    end
  end

  defp row_to_coffee_shop(_), do: nil # Ignore rows with incorrect number of columns
end
