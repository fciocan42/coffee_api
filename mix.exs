defmodule CoffeeApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :coffee_api,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CoffeeApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.7.10"},
      {:finch, "~> 0.16"},
      {:mox, "~> 1.0", only: :test},
      {:nimble_csv, "~> 1.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the project.
  # For example, to install assets, you can run: "mix assets.deploy"
  defp aliases do
    [
    ]
  end
end
