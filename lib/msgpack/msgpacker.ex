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
  def pack(value) when value >= 0 and 128 > value, do: <<0::1, value::7>>
  def pack(value) when value >= 0 and 256 > value, do: <<0xCC, value::8>>
  def pack(value) when value >= 0 and 0x10000 > value, do: <<0xCD, value::16>>
  def pack(value) when value >= 0 and 0x100000000 > value, do: <<0xCE, value::32>>
end
