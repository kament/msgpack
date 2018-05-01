defmodule MsgpackTest do
  use ExUnit.Case
  doctest Msgpack

  test "greets the world" do
    assert Msgpack.hello() == :world
  end
end
