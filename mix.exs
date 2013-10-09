defmodule Mudkip.Mixfile do
  use Mix.Project

  def project do
    [ app: :mudkip,
      version: "0.0.1",
      elixir: "~> 0.10.2",
      deps: [],
      compile_path: "ebin" ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Mudkip, [] }]
  end

end
