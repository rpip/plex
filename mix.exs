defmodule Plex.Mixfile do
  use Mix.Project

  def project do
    [app: :plex,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     escript: escript]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.10", only: :docs},
     {:earmark, "~> 0.1", only: :docs}]
  end

  def escript do
    [
        main_module: Plex.CLI,
        emu_args: "-noshell -noinput -elixir ansi_enabled true"
    ]
  end
end
