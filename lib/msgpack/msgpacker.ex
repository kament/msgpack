defprotocol Msgpacker do
  @doc "Pack elixir obejct to msgpack value"
  def pack(item)
end

defimpl Msgpacker, for: Atom do
  def pack(nil), do: <<0xC0>>
  def pack(false), do: <<0xC2>>
  def pack(true), do: <<0xC3>>
end

defimpl Msgpacker, for: Integer do
  def pack(value) when value >= 0, do: pack_unsigned_int(value)
  def pack(value) when value < 0, do: pack_signed_int(value)

  defp pack_signed_int(value) when value >= -32, do: <<0b111::3, value::5>>
  defp pack_signed_int(value) when value >= -127, do: <<0xD0, value::8>>
  defp pack_signed_int(value) when value >= -32_767, do: <<0xD1, value::16>>
  defp pack_signed_int(value) when value >= -2_147_483_647, do: <<0xD2, value::32>>
  defp pack_signed_int(value) when value >= -9_223_372_036_854_775_808, do: <<0xD3, value::64>>

  defp pack_unsigned_int(value) when 128 > value, do: <<0::1, value::size(7)>>
  defp pack_unsigned_int(value) when 256 > value, do: <<0xCC, value::8>>
  defp pack_unsigned_int(value) when 65_536 > value, do: <<0xCD, value::16>>
  defp pack_unsigned_int(value) when 4_294_967_296 > value, do: <<0xCE, value::32>>
  defp pack_unsigned_int(value) when 18_446_744_073_709_551_616 > value, do: <<0xCF, value::64>>
end

defimpl Msgpacker, for: Float do
  def pack(num) do
    <<0xCB, num::float>>
  end
end

defimpl Msgpacker, for: BitString do
  def pack(value) when is_binary(value) do
    size = byte_size(value)

    cond do
      size < 32 ->
        <<0b101::3, size::5>> <> value

      size < 255 ->
        <<0xD9, size::8>> <> value

      size < 65_535 ->
        <<0xDA, size::16>> <> value

      size < 4_294_967_295 ->
        <<0xDB, size::32>> <> value

      true ->
        throw(:not_implemented)
    end
  end
end

defimpl Msgpacker, for: Map do
  def pack(map) do
    size = Map.keys(map) |> Enum.count()

    cond do
      size <= 15 ->
        <<0b10000000 + size>> <> pack_map(map)

      size <= 65_535 ->
        <<0xDE, size::16>> <> pack_map(map)

      size <= 4_294_967_295 ->
        <<0xDF, size::32>> <> pack_map(map)

      true ->
        throw(:not_implemented)
    end
  end

  defp pack_map(map) do
    Map.keys(map)
    |> Enum.map(fn k -> @protocol.pack(k) <> @protocol.pack(map[k]) end)
    |> Enum.reduce(<<>>, fn p, a -> a <> p end)
  end
end

defimpl Msgpacker, for: List do
  def pack(l) do
    length = length(l)

    cond do
      length <= 15 ->
        <<0b10010000 + length>> <> pack_list(l)

      length <= 65_535 ->
        <<0xDC, length::16>> <> pack_list(l)

      length <= 4_294_967_295 ->
        <<0xDD, length::32>> <> pack_list(l)

      true ->
        throw(:not_implemented)
    end
  end

  defp pack_list(l) do
    l |> Enum.map(fn e -> @protocol.pack(e) end)
    |> Enum.reduce(<<>>, fn p, a -> a <> p end)
  end
end
