defmodule MsgpackerTest do
  use ExUnit.Case
  doctest Msgpacker

  test "should pack nil" do
    assert Msgpacker.pack(nil) == [0xc0]
  end

  test "shpuld pack true" do
    assert Msgpacker.pack(true) == [0xc3]
  end

  test "should pack false" do
    assert Msgpacker.pack(false) == [0xc2]
  end
end
