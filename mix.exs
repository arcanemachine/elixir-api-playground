defmodule ApiPlayground.MixProject do
  use Mix.Project

  def project do
    [
      app: :api_playground,
      version: "0.1.0",
      elixir: "~> 1.15",
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:jason, "~> 1.4.0"},
      {:sweet_xml, "~> 0.7.4"},
      {:req, "~> 0.4.0"},
      {:httpoison, "~> 2.1.0"},
      {:timex, "~> 3.7.11"}
    ]
  end
end
