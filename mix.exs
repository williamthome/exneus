defmodule Exneus.MixProject do
  use Mix.Project

  def project do
    [
      app: :exneus,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:euneus, "~> 2.1"},
      {:euneus, git: "https://github.com/williamthome/euneus", branch: "main"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
