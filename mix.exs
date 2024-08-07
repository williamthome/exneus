defmodule Exneus.MixProject do
  use Mix.Project

  def project do
    [
      app: :exneus,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      preferred_cli_env: [
        ci: :test
      ],
      deps: deps(),

      # Docs
      name: "Exneus",
      source_url: "https://github.com/williamthome/exneus",
      homepage_url: "https://github.com/williamthome/exneus",
      docs: [
        main: "Exneus",
        extras: [
          "README.md": [title: "Overview"],
          "LICENSE.md": [title: "License"]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      ci: [
        "compile --warnings-as-errors",
        "format --check-formatted",
        "test"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:euneus, "~> 2.2"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end
end
