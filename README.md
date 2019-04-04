# pcd_8544

**Elixir library for controlling PCD8544 (Nokia 5110) displays**

Built using Circuits SPI library.

Currently it supports just the basic character output.

## Usage

```elixir
GenServer.start_link(Pcd8544, [], name: Pcd8544)
Pcd8544.clear
Pcd8544.cursorpos(1,1)
Pcd8544.write("Hello from pcd_8544!")
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pcd_8544` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pcd_8544, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/pcd_8544](https://hexdocs.pm/pcd_8544).

