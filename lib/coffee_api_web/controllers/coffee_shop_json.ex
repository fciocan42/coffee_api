defmodule CoffeeApiWeb.CoffeeShopJSON do
  def index(%{coffee_shops: coffee_shops}) do
    %{data: coffee_shops}
  end

  def error(%{message: message}) do
    %{error: message}
  end
end
