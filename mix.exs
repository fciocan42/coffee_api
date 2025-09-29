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
      {:telemetry_metrics, "~> 0.6"},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.11"},
      {:mox, "~> 1.0", only: :test},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:nimble_csv, "~> 1.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the project.
  # For example, to install assets, you can run: "mix assets.deploy"
  defp aliases do
    [
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
