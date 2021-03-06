defmodule Msgunpacker do
  @doc "Unpack msgpacked atom"
  def unpack(<<0xC0::8, rest::binary>>), do: UnpackResult.new(nil, rest)

  def unpack(<<0xC2, rest::binary>>), do: UnpackResult.new(false, rest)
  def unpack(<<0xC3, rest::binary>>), do: UnpackResult.new(true, rest)

  @doc "Unpack integar"
  def unpack(<<0::1, value::7, rest::binary>>), do: UnpackResult.new(value, rest)
  def unpack(<<0xCC, value::8, rest::binary>>), do: UnpackResult.new(value, rest)
  def unpack(<<0xCD, value::16, rest::binary>>), do: UnpackResult.new(value, rest)
  def unpack(<<0xCE, value::32, rest::binary>>), do: UnpackResult.new(value, rest)
  def unpack(<<0xCF, value::64, rest::binary>>), do: UnpackResult.new(value, rest)
  def unpack(<<0b111::3, value::5, rest::binary>>), do: UnpackResult.new(value - 32, rest)
  def unpack(<<0xD0, value::8, rest::binary>>), do: UnpackResult.new(value - 256, rest)
  def unpack(<<0xD1, value::16, rest::binary>>), do: UnpackResult.new(value - 65_536, rest)
  def unpack(<<0xD2, value::32, rest::binary>>), do: UnpackResult.new(value - 4_294_967_296, rest)

  def unpack(<<0xD3, value::64, rest::binary>>),
    do: UnpackResult.new(value - 18_446_744_073_709_551_616, rest)

  @doc "Unpack float"
  def unpack(<<0xCB, num::float, rest::binary>>), do: UnpackResult.new(num, rest)

  @doc "Unpack string"
  def unpack(<<0b101::3, length::5, value::size(length)-bytes, rest::binary>>) do
    UnpackResult.new(value, rest)
  end

  def unpack(<<0xD9, length::8, value::size(length)-bytes, rest::binary>>) do
    UnpackResult.new(value, rest)
  end

  def unpack(<<0xDA, length::16, value::size(length)-bytes, rest::binary>>) do
    UnpackResult.new(value, rest)
  end

  def unpack(<<0xDB, length::32, value::size(length)-bytes, rest::binary>>) do
    UnpackResult.new(value, rest)
  end

  @doc "Unpack List"
  # Not working for some reason
  def unpack(<<0b1001::4, length::4, rest::bits>>) do
    unpack_list(rest, [], length)
  end

  def unpack(<<0xDC::8, length::16, rest::binary>>) do
    unpack_list(rest, [], length)
  end

  def unpack(<<0xDD::8, length::32, rest::binary>>) do
    unpack_list(rest, [], length)
  end

  @doc "Unpack map"
  def unpack(<<0b1000::4, length::4, rest::binary>>) do
    unpack_map(rest, %{}, length)
  end

  def unpack(<<0xDE::8, length::16, rest::binary>>) do
    unpack_map(rest, %{}, length)
  end

  def unpack(<<0xDF::8, length::32, rest::binary>>) do
    unpack_map(rest, %{}, length)
  end

  defp unpack_list(<<>>, result, _) do
    UnpackResult.new(Enum.reverse(result), <<>>)
  end

  defp unpack_list(value, result, 0) do
    res = unpack(value)
    UnpackResult.new(Enum.reverse([res.value | result]), res.rest)
  end

  defp unpack_list(value, result, length) do
    res = unpack(value)
    unpack_list(res.rest, [res.value | result], length - 1)
  end

  defp unpack_map(<<>>, result_map, _) do
    UnpackResult.new(result_map, <<>>)
  end

  defp unpack_map(value, result_map, 0) do
    UnpackResult.new(result_map, value)
  end

  defp unpack_map(value, result_map, index) do
    key_result = unpack(value)
    value_result = unpack(key_result.rest)

    map = Map.put_new(result_map, key_result.value, value_result.value)

    unpack_map(value_result.rest, map, index - 1)
  end
end
