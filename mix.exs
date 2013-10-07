defmodule Mudkip.Mixfile do
  use Mix.Project

  def project do
    [ app: :mudkip,
      version: "0.0.1",
      elixir: "~> 0.10.3",
      deps: deps,
      compile_path: "ebin" ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Mudkip, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end
end