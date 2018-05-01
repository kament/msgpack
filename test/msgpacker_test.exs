defmodule MsgpackerTest do
  use ExUnit.Case
  doctest Msgpacker

  test "should pack nil" do
    assert Msgpacker.pack(nil) == <<0xc0>>
  end
end
