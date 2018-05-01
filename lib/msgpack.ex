defmodule Msgpack do
  @doc "converts data to it's msgpack representation"
  def pack(data) do
    Msgpacker.pack(data)
  end

  @doc "converts msgpack to data to JSON"
  def unpack(data) do
    Msgunpacker.unpack(data)
  end
end
