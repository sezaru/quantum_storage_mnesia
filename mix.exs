defmodule QuantumStorageMnesia.MixProject do
  use Mix.Project

  @app :quantum_storage_mnesia
  @name "Quantum Storage Mnesia"
  @description "Quantum Storage Adapter based on Mnesia"
  @version "0.1.0"
  @github "https://github.com/sezaru/#{@app}"
  @author "Eduardo Barreto Alexandre"
  @license "MIT"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.10",
      name: @name,
      description: @description,
      deps: deps(),
      docs: docs(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: preferred_cli_env(),
      dialyzer: dialyzer()
    ]
  end

  def application, do: [extra_applications: [:logger, :mnesia]]

  defp deps do
    [
      {:memento, "~> 0.3.1"},
      {:quantum, "~> 3.0"},
      {:ex_doc, "~> 0.22.1", only: [:dev, :docs], runtime: false},
      {:excoveralls, "~> 0.13", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @github,
      extras: [
        "README.md"
      ]
    ]
  end

  defp package do
    [
      name: @app,
      maintainers: [@author],
      licenses: [@license],
      files: ~w(mix.exs lib README.md),
      links: %{"Github" => @github}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp preferred_cli_env do
    [
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test
    ]
  end

  defp dialyzer, do: [plt_add_apps: [:mix, :eex, :decimal_arithmetic]]
end
