defmodule Pcd8544.MixProject do
  use Mix.Project

  def project do
    [
      app: :pcd_8544,
      description: "Elixir driver for PCD8544 based LCD displays",
      version: "0.2.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/jablan/pcd_8544"},
      source_url: "https://github.com/jablan/pcd_8544"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_gpio, "~> 0.1"},
      {:circuits_spi, "~> 0.1"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
    ]
  end
end
