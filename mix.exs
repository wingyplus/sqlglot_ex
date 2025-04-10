defmodule SQLGlot.MixProject do
  use Mix.Project

  def project do
    [
      app: :sqlglot_ex,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: ["mneme.test": :test, "mneme.watch": :test]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:pythonx, github: "livebook-dev/pythonx", branch: "main"},
      {:mneme, "~> 0.10", only: :test}
    ]
  end
end
