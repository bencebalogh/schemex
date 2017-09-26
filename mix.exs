defmodule Schemex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :schemex,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      {:httpoison, "~> 0.12"},
      {:poison, "~> 3.1"},
      {:bypass, "~> 0.8", only: :test},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end

  defp package do
    [
      name: "schemex",
      links: %{"GitHub" => "https://github.com/bencebalogh/schemex"},
      licenses: ["Unlicensed"],
      maintainers: ["Bence Balogh"]
    ]
  end

  defp description do
    "Small Elixir wrapper for Confluent Schema Registry"
  end
end
