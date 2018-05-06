defmodule Msgunpacker do

  @doc "Unpack msgpacked atom"
  def unpack([0xc0]), do: nil

  def unpack([0xc2]), do: false
  def unpack([0xc3]), do: true

  @doc "Unpack integar between 0 and 2^7"
  def unpack(<<0::1, value::7>>), do: value
end
