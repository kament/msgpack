defmodule Msgunpacker do
  @doc "Unpack msgpacked atom"
  def unpack(<<0xC0>>), do: nil

  def unpack(<<0xC2>>), do: false
  def unpack(<<0xC3>>), do: true

  @doc "Unpack integar"
  def unpack(<<0::1, value::7>>), do: value
  def unpack(<<0xCC, value::8>>), do: value
  def unpack(<<0xCD, value::16>>), do: value
  def unpack(<<0xCE, value::32>>), do: value
  def unpack(<<0xCF, value::64>>), do: value
  def unpack(<<0b111::3, value::5>>), do: value - 32
  def unpack(<<0xD0, value::8>>), do: value - 256
  def unpack(<<0xD1, value::16>>), do: value - 65_536
  def unpack(<<0xD2, value::32>>), do: value - 4_294_967_296
  def unpack(<<0xD3, value::64>>), do: value - 18_446_744_073_709_551_616
end
