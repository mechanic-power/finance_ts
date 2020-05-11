defmodule FinanceTS.MixProject do
  use Mix.Project

  def project do
    [
      app: :finance_ts,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.post": :test,
        credo: :test,
        "test.watch": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, ">= 0.0.0", only: :test},
      {:excoveralls, "~> 0.7", only: :test},
      {:jason, "~> 1.0"},
      {:mix_test_watch, "~> 1.0", only: :test, runtime: false},
      {:tesla, "~> 1.3.0"}
    ]
  end
end
