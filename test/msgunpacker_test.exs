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
  test "should unpack int7" do
    assert Msgunpacker.unpack(<<0x0b>>) == 11
  end

  test "should correctly unpack 0" do
    assert Msgunpacker.unpack(<<0>>) == 0
  end

  test "should correctly unpack 127" do
    assert Msgunpacker.unpack(<<0x7F>>) == 127
  end

  test "should correctly unpack 128" do
    assert Msgunpacker.unpack(<<0xCC, 0x80>>) == 128
  end

  test "should correctly unpack 255" do
    assert Msgunpacker.unpack(<<0xCC, 0xFF>>) == 255
  end

  test "should correctly unpack 256" do
    assert Msgunpacker.unpack(<<0xCD, 0x01, 0x00>>) == 256
  end

  test "should correctly unpack 65,535" do
    assert Msgunpacker.unpack(<<0xCD, 0xFF, 0xFF>>) == 65_535
  end

  test "should correctly unpack 65,536" do
    assert Msgunpacker.unpack(<<0xCE, 0x00, 0x01, 0x00, 0x00>>) == 65_536
  end

  test "should correctly unpack 4,294,967,295" do
    assert Msgunpacker.unpack(<<0xCE, 0xFF, 0xFF, 0xFF, 0xFF>>) == 4_294_967_295
  end
end
