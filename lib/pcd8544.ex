defmodule Pcd8544 do
  @moduledoc """
  Documentation for Pcd8544.
  """

  alias Circuits.SPI
  alias Circuits.GPIO

  @dc_pin 23
  @rst_pin 24
  @spi_bus 0

  @commands [
    powerdown: 0x04,
    entrymode: 0x02,
    extendedinstruction: 0x01,
    display_blank: 0x0,
    display_normal: 0x4,
    display_all_on: 0x1,
    display_inverted: 0x5,
    function_set_basic: 0x20,
    function_set_extended: 0x21,
    displaycontrol: 0x08,
    set_y_addr: 0x40,
    set_x_addr: 0x80,
    set_temp: 0x04,
    set_bias: 0x10,
    set_vop: 0x80,
  ]

  @example <<0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFC, 0xFE, 0xFF, 0xFC, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF0, 0xF0, 0xE0, 0xE0, 0xC0, 0x80, 0xC0, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x1F, 0x3F, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xE7, 0xC7, 0xC7, 0x87, 0x8F, 0x9F, 0x9F, 0xFF, 0xFF, 0xFF, 0xC1, 0xC0, 0xE0, 0xFC, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC, 0xFC, 0xFC, 0xFC, 0xFE, 0xFE, 0xFE, 0xFC, 0xFC, 0xF8, 0xF8, 0xF0, 0xE0, 0xC0, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0xC0, 0xE0, 0xF1, 0xFB, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x1F, 0x0F, 0x0F, 0x87, 0xE7, 0xFF, 0xFF, 0xFF, 0x1F, 0x1F, 0x3F, 0xF9, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xF8, 0xFD, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F, 0x0F, 0x07, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0x7E, 0x3F, 0x3F, 0x0F, 0x1F, 0xFF, 0xFF, 0xFF, 0xFC, 0xF0, 0xE0, 0xF1, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC, 0xF0, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x0F, 0x1F, 0x3F, 0x7F, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x7F, 0x1F, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>

  @charset %{
    "!" => [ 0x00, 0x00, 0x5f, 0x00, 0x00 ],
    "\"" => [ 0x00, 0x07, 0x00, 0x07, 0x00 ],
    "#" => [ 0x14, 0x7f, 0x14, 0x7f, 0x14 ],
    "$" => [ 0x24, 0x2a, 0x7f, 0x2a, 0x12 ],
    "%" => [ 0x23, 0x13, 0x08, 0x64, 0x62 ],
    "&" => [ 0x36, 0x49, 0x55, 0x22, 0x50 ],
    "'" => [ 0x00, 0x05, 0x03, 0x00, 0x00 ],
    "(" => [ 0x00, 0x1c, 0x22, 0x41, 0x00 ],
    ")" => [ 0x00, 0x41, 0x22, 0x1c, 0x00 ],
    "*" => [ 0x14, 0x08, 0x3e, 0x08, 0x14 ],
    "+" => [ 0x08, 0x08, 0x3e, 0x08, 0x08 ],
    "," => [ 0x00, 0x50, 0x30, 0x00, 0x00 ],
    "-" => [ 0x08, 0x08, 0x08, 0x08, 0x08 ],
    "." => [ 0x00, 0x60, 0x60, 0x00, 0x00 ],
    "/" => [ 0x20, 0x10, 0x08, 0x04, 0x02 ],
    "0" => [ 0x3e, 0x51, 0x49, 0x45, 0x3e ],
    "1" => [ 0x00, 0x42, 0x7f, 0x40, 0x00 ],
    "2" => [ 0x42, 0x61, 0x51, 0x49, 0x46 ],
    "3" => [ 0x21, 0x41, 0x45, 0x4b, 0x31 ],
    "4" => [ 0x18, 0x14, 0x12, 0x7f, 0x10 ],
    "5" => [ 0x27, 0x45, 0x45, 0x45, 0x39 ],
    "6" => [ 0x3c, 0x4a, 0x49, 0x49, 0x30 ],
    "7" => [ 0x01, 0x71, 0x09, 0x05, 0x03 ],
    "8" => [ 0x36, 0x49, 0x49, 0x49, 0x36 ],
    "9" => [ 0x06, 0x49, 0x49, 0x29, 0x1e ],
    ":" => [ 0x00, 0x36, 0x36, 0x00, 0x00 ],
    ";" => [ 0x00, 0x56, 0x36, 0x00, 0x00 ],
    "<" => [ 0x08, 0x14, 0x22, 0x41, 0x00 ],
    "=" => [ 0x14, 0x14, 0x14, 0x14, 0x14 ],
    ">" => [ 0x00, 0x41, 0x22, 0x14, 0x08 ],
    "?" => [ 0x02, 0x01, 0x51, 0x09, 0x06 ],
    "@" => [ 0x32, 0x49, 0x79, 0x41, 0x3e ],
    "A" => [ 0x7e, 0x11, 0x11, 0x11, 0x7e ],
    "B" => [ 0x7f, 0x49, 0x49, 0x49, 0x36 ],
    "C" => [ 0x3e, 0x41, 0x41, 0x41, 0x22 ],
    "D" => [ 0x7f, 0x41, 0x41, 0x22, 0x1c ],
    "E" => [ 0x7f, 0x49, 0x49, 0x49, 0x41 ],
    "F" => [ 0x7f, 0x09, 0x09, 0x09, 0x01 ],
    "G" => [ 0x3e, 0x41, 0x49, 0x49, 0x7a ],
    "H" => [ 0x7f, 0x08, 0x08, 0x08, 0x7f ],
    "I" => [ 0x00, 0x41, 0x7f, 0x41, 0x00 ],
    "J" => [ 0x20, 0x40, 0x41, 0x3f, 0x01 ],
    "K" => [ 0x7f, 0x08, 0x14, 0x22, 0x41 ],
    "L" => [ 0x7f, 0x40, 0x40, 0x40, 0x40 ],
    "M" => [ 0x7f, 0x02, 0x0c, 0x02, 0x7f ],
    "N" => [ 0x7f, 0x04, 0x08, 0x10, 0x7f ],
    "O" => [ 0x3e, 0x41, 0x41, 0x41, 0x3e ],
    "P" => [ 0x7f, 0x09, 0x09, 0x09, 0x06 ],
    "Q" => [ 0x3e, 0x41, 0x51, 0x21, 0x5e ],
    "R" => [ 0x7f, 0x09, 0x19, 0x29, 0x46 ],
    "S" => [ 0x46, 0x49, 0x49, 0x49, 0x31 ],
    "T" => [ 0x01, 0x01, 0x7f, 0x01, 0x01 ],
    "U" => [ 0x3f, 0x40, 0x40, 0x40, 0x3f ],
    "V" => [ 0x1f, 0x20, 0x40, 0x20, 0x1f ],
    "W" => [ 0x3f, 0x40, 0x38, 0x40, 0x3f ],
    "X" => [ 0x63, 0x14, 0x08, 0x14, 0x63 ],
    "Y" => [ 0x07, 0x08, 0x70, 0x08, 0x07 ],
    "Z" => [ 0x61, 0x51, 0x49, 0x45, 0x43 ],
    "[" => [ 0x00, 0x7f, 0x41, 0x41, 0x00 ],
    "]" => [ 0x00, 0x41, 0x41, 0x7f, 0x00 ],
    "^" => [ 0x04, 0x02, 0x01, 0x02, 0x04 ],
    "_" => [ 0x40, 0x40, 0x40, 0x40, 0x40 ],
    "`" => [ 0x00, 0x01, 0x02, 0x04, 0x00 ],
    "a" => [ 0x20, 0x54, 0x54, 0x54, 0x78 ],
    "b" => [ 0x7f, 0x48, 0x44, 0x44, 0x38 ],
    "c" => [ 0x38, 0x44, 0x44, 0x44, 0x20 ],
    "d" => [ 0x38, 0x44, 0x44, 0x48, 0x7f ],
    "e" => [ 0x38, 0x54, 0x54, 0x54, 0x18 ],
    "f" => [ 0x08, 0x7e, 0x09, 0x01, 0x02 ],
    "g" => [ 0x0c, 0x52, 0x52, 0x52, 0x3e ],
    "h" => [ 0x7f, 0x08, 0x04, 0x04, 0x78 ],
    "i" => [ 0x00, 0x44, 0x7d, 0x40, 0x00 ],
    "j" => [ 0x20, 0x40, 0x44, 0x3d, 0x00 ],
    "k" => [ 0x7f, 0x10, 0x28, 0x44, 0x00 ],
    "l" => [ 0x00, 0x41, 0x7f, 0x40, 0x00 ],
    "m" => [ 0x7c, 0x04, 0x18, 0x04, 0x78 ],
    "n" => [ 0x7c, 0x08, 0x04, 0x04, 0x78 ],
    "o" => [ 0x38, 0x44, 0x44, 0x44, 0x38 ],
    "p" => [ 0x7c, 0x14, 0x14, 0x14, 0x08 ],
    "q" => [ 0x08, 0x14, 0x14, 0x18, 0x7c ],
    "r" => [ 0x7c, 0x08, 0x04, 0x04, 0x08 ],
    "s" => [ 0x48, 0x54, 0x54, 0x54, 0x20 ],
    "t" => [ 0x04, 0x3f, 0x44, 0x40, 0x20 ],
    "u" => [ 0x3c, 0x40, 0x40, 0x20, 0x7c ],
    "v" => [ 0x1c, 0x20, 0x40, 0x20, 0x1c ],
    "w" => [ 0x3c, 0x40, 0x30, 0x40, 0x3c ],
    "x" => [ 0x44, 0x28, 0x10, 0x28, 0x44 ],
    "y" => [ 0x0c, 0x50, 0x50, 0x50, 0x3c ],
    "z" => [ 0x44, 0x64, 0x54, 0x4c, 0x44 ],
    "{" => [ 0x00, 0x08, 0x36, 0x41, 0x00 ],
    "|" => [ 0x00, 0x00, 0x7f, 0x00, 0x00 ],
    "}" => [ 0x00, 0x41, 0x36, 0x08, 0x00 ],
    "~" => [ 0x10, 0x08, 0x08, 0x10, 0x08 ],
  }

  def handle_call(:display, [spi: spi, dc: dc] = state) do
    state
    |> command(:set_y_addr)
    |> command(:set_x_addr)
    :ok = GPIO.write(dc, 1)
    SPI.transfer(spi, @example)
    {:noreply, state}
  end

  def handle_call(:char, c, [spi: spi, dc: dc] = state) do
    :ok = GPIO.write(dc, 1)
    SPI.transfer(spi, @charset[c])
    {:noreply, state}
  end

  def init(opts \\ []) do
    {:ok, spi} = SPI.open("spidev#{Keyword.get(opts, :spi_bus, @spi_bus)}.0")
    {:ok, dc} = GPIO.open(Keyword.get(opts, :dc_pin, @dc_pin), :output)
    {:ok, rst} = GPIO.open(Keyword.get(opts, :rst_pin, @rst_pin), :output)
    state = [spi: spi, dc: dc, rst: rst]
    reset(state)
    {:ok, state}
  end

  def display() do
    GenServer.call(__MODULE__, :display)
  end

  def char(c) do
    GenServer.call(__MODULE__, :char, c)
  end

  def cursorpos(x, y) do
    GenServer.call(__MODULE__, :cursorpos, [x, y])
  end

  def command([spi: spi, dc: dc] = state, c) do
    :ok = GPIO.write(dc, 0)
    SPI.transfer(spi, <<@commands[c]>>)
    state
  end

  def reset([rst: rst] = state) do
    :ok = GPIO.write(rst, 0)
    Process.sleep(100)
    :ok = GPIO.write(rst, 0)
    state
  end
end
