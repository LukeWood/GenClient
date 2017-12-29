defmodule GenClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gen_client,
      version: "1.0.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/LukeWood/GenClient/"
    ]
  end

  defp description() do
    "GenClient is metaprogramming library made to generate boilerplate code that I found myself repeatedly writing and changing when working with GenServers."
  end

  defp package() do
    [
      name: "GenClient",
      maintainers: ["Luke Wood"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/LukeWood/GenClient/"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
