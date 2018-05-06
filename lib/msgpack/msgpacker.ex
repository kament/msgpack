defprotocol Msgpacker do
  @doc "Pack elixir obejct to msgpack value"
  def pack(item)
end

defimpl Msgpacker, for: Atom do
  def pack(nil) do [0xc0] end

  def pack(false) do [0xc2] end
  def pack(true) do [0xc3] end
end
