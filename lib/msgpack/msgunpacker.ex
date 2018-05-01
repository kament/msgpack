defmodule Msgunpacker do
  def unpack([0xc0]), do: nil

  def unpack([0xc2]), do: false
  def unpack([0xc3]), do: true
end
