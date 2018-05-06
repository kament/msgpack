defprotocol Msgpacker do
  @doc "Pack elixir obejct to msgpack value"
  def pack(item)
end

defimpl Msgpacker, for: Atom do
  def pack(nil) do [0xC0] end

  def pack(false) do [0xC2] end
  def pack(true) do [0xC3] end
end

defimpl Msgpacker, for: Integer do
  def pack(value) when value >= 0, do: pack_unsigned_int(value)
  def pack(value) when value < 0, do: pack_signed_int(value)

  defp pack_signed_int(value) when value >= -32, do: <<0b111::3, value::5>>
  defp pack_signed_int(value) when value >= -127, do: <<0xD0, value::8>>
  defp pack_signed_int(value) when value >= -32_767, do: <<0xD1, value::16>>
  defp pack_signed_int(value) when value >= -2_147_483_647, do: <<0xD2, value::32>>
  defp pack_signed_int(value) when value >= -9_223_372_036_854_775_808, do: <<0xD3, value::64>>

  defp pack_unsigned_int(value) when 128 > value, do: <<0::1, value::7>>
  defp pack_unsigned_int(value) when 256 > value, do: <<0xCC, value::8>>
  defp pack_unsigned_int(value) when 65_536 > value, do: <<0xCD, value::16>>
  defp pack_unsigned_int(value) when 4_294_967_296 > value, do: <<0xCE, value::32>>
  defp pack_unsigned_int(value) when 18_446_744_073_709_551_616 > value, do: <<0xCF, value::64>>
end
