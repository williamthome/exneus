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
        ci: :test,
        "benchmark.decode": :benchmark,
        "benchmark.encode": :benchmark
      ],
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),

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
      ],
      "benchmark.decode": ["run benchmark/exneus_decode_benchmark.exs"],
      "benchmark.encode": ["run benchmark/exneus_encode_benchmark.exs"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:euneus, git: "https://github.com/williamthome/euneus", branch: "main"},
      # dev
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      # benchmark
      {:benchee, "~> 1.1", only: :benchmark, runtime: false},
      {:benchee_html, "~> 1.0", only: :benchmark, runtime: false},
      {:benchee_markdown, "~> 0.3", only: :benchmark, runtime: false},
      {:thoas, "~> 1.2", only: :benchmark, runtime: false},
      {:jason, "~> 1.4", only: :benchmark, runtime: false},
      {:json, "~> 1.4", only: :benchmark, runtime: false},
      {:jsone, "~> 1.6", only: :benchmark, runtime: false},
      {:jsx, "~> 3.1", only: :benchmark, runtime: false},
      {:jiffy, "~> 1.1", only: :benchmark, runtime: false}
    ]
  end

  defp elixirc_paths(:benchmark), do: ["lib", "benchmark"]
  defp elixirc_paths(_), do: ["lib"]
end
