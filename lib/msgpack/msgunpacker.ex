defmodule Msgunpacker do

  @doc "Unpack msgpacked atom"
  def unpack([0xC0]), do: nil

  def unpack([0xC2]), do: false
  def unpack([0xC3]), do: true

  @doc "Unpack integar between 0 and 2^7"
  def unpack(<<0::1, value::7>>), do: value
  def unpack(<<0xCC, value::8>>), do: value
end
