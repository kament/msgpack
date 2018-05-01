defprotocol Msgpack do
  @doc "converts data to it's msgpack representation"
  def encode(data)

  @doc "converts msgpack to data - specified by the implementation"
  def decode(data)
end
