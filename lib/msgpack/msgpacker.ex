defprotocol Msgpacker do
  @doc "Pack elixir obejct to msgpack value"
  def pack(item)
end

defimpl Msgpacker, for: Atom do
  def pack(nil) do [0xc0] end

  def pack(false) do [0xc2] end
  def pack(true) do [0xc3] end
end

defimpl Msgpacker, for: Integer do
  def pack(value) when value >= 0 and 128 > value, do: <<0::1, value::7>>
end
