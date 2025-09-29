defmodule CoffeeApiWeb.HealthJSON do
  def index(_assigns) do
    %{status: "ok"}
  end

  def degraded(%{reason: reason}) do
    %{status: "degraded", reason: reason}
  end
end
