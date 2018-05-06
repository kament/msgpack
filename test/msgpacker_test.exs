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
    assert Msgpacker.pack(127) == <<0x7F>>
  end

  test "should pack int7" do
    assert Msgpacker.pack(11) == <<0x0B>>
  end

  test "should correctly pack 128" do
    assert Msgpacker.pack(128) == <<0xCC, 0x80>>
  end

  test "should correctly pack 255" do
    assert Msgpacker.pack(255) == <<0xCC, 0xFF>>
  end

  test "should correctly pack 65,536" do
    assert Msgpacker.pack(65_536) == <<0xCE, 0x00, 0x01, 0x00, 0x00>>
  end

  test "should correctly pack 4,294,967,295" do
    assert Msgpacker.pack(4_294_967_295) == <<0xCE, 0xFF, 0xFF, 0xFF, 0xFF>>
  end

  test "should correctly pack 4,294,967,296" do
    assert Msgpacker.pack(4_294_967_296) ==
             <<0xCF, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00>>
  end

  test "should correctly pack 18,446,744,073,709,551,615" do
    assert Msgpacker.pack(18_446_744_073_709_551_615) ==
             <<0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF>>
  end

  test "should correctly pack -32" do
    assert Msgpacker.pack(-32) == <<0xE0>>
  end

  test "should correctly pack -33" do
    assert Msgpacker.pack(-33) == <<0xD0, 0xDF>>
  end

  test "should correctly pack -127" do
    assert Msgpacker.pack(-127) == <<0xD0, 0x81>>
  end

  test "should correctly pack -128" do
    assert Msgpacker.pack(-128) == <<0xD1, 0xFF, 0x80>>
  end

  test "should correctly pack -32_767" do
    assert Msgpacker.pack(-32_767) == <<0xD1, 0x80, 0x01>>
  end

  test "should correctly pack -32_768" do
    assert Msgpacker.pack(-32_768) == <<0xD2, 0xFF, 0xFF, 0x80, 0x00>>
  end

  test "should correctly pack -2_147_483_647" do
    assert Msgpacker.pack(-2_147_483_647) == <<0xD2, 0x80, 0x00, 0x00, 0x01>>
  end

  test "should correctly pack -2_147_483_648" do
    assert Msgpacker.pack(-2_147_483_648) ==
             <<0xD3, 0xFF, 0xFF, 0xFF, 0xFF, 0x80, 0x00, 0x00, 0x00>>
  end

  test "should correctly pack -9_223_372_036_854_775_808" do
    assert Msgpacker.pack(-9_223_372_036_854_775_808) ==
             <<0xD3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>
  end
end
