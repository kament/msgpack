defmodule Msgunpacker do

  @doc "Unpack msgpacked atom"
  def unpack([0xC0]), do: nil

  def unpack([0xC2]), do: false
  def unpack([0xC3]), do: true

  @doc "Unpack integar"
  def unpack(<<0::1, value::7>>), do: value
  def unpack(<<0xCC, value::8>>), do: value
  def unpack(<<0xCD, value::16>>), do: value
  def unpack(<<0xCE, value::32>>), do: value
  def unpack(<<0xCF, value::64>>), do: value
end
