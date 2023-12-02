defmodule AdventOfCode.Mixfile do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "0.0.1",
      elixir: "~> 1.0",
      deps: deps(),
      preferred_cli_env: [espec: :test],
    ]
  end

  def deps do
    [
      # {:ex_parameterized, "~> 1.3.7"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      # {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}, # Static analysis
      {:espec, "~> 1.9.1", only: :test},
    ]
  end

end