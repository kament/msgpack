defmodule MsgpackerTest do
  use ExUnit.Case
  doctest Msgpacker

  @doc "Test Atoms packing"
  test "should pack nil" do
    assert Msgpacker.pack(nil) == [0xC0]
  end

  test "shpuld pack true" do
    assert Msgpacker.pack(true) == [0xC3]
  end

  test "should pack false" do
    assert Msgpacker.pack(false) == [0xC2]
  end

  @doc "Test Integer packing"
  test "should correctly pack 0" do
    assert Msgpacker.pack(0) == <<0>>
  end

  test "should correctly pack 127" do
    assert Msgpacker.pack(127) == <<0x7f>>
  end

  test "should pack int7" do
    assert Msgpacker.pack(11) == <<0x0b>>
  end
end
