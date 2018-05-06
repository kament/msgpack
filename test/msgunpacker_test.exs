defmodule MsgunpackerTest do
  use ExUnit.Case
  doctest Msgpacker

   @doc "Test Atoms unpacking"
  test "should unpack nil" do
    assert Msgunpacker.unpack([0xC0]) == nil
  end

  test "should unpack true" do
    assert Msgunpacker.unpack([0xC3]) == true
  end

  test "should unpack false" do
    assert Msgunpacker.unpack([0xC2]) == false
  end

  @doc "Test Integer unpacking"
  test "should unpack int8" do
    assert Msgunpacker.unpack(<<0x0b>>) == 11
  end

  test "should correctly unpack 0" do
    assert Msgunpacker.unpack(<<0>>) == 0
  end

  test "should correctly unpack 127" do
    assert Msgunpacker.unpack(<<0x7f>>) == 127
  end
end
