defmodule MsgunpackerTest do
  use ExUnit.Case
  doctest Msgpacker

  @doc "Test Atoms unpacking"
  test "should unpack nil" do
    assert Msgunpacker.unpack(<<0xC0>>) == nil
  end

  test "should unpack true" do
    assert Msgunpacker.unpack(<<0xC3>>) == true
  end

  test "should unpack false" do
    assert Msgunpacker.unpack(<<0xC2>>) == false
  end

  @doc "Test Integer unpacking"
  test "should unpack int7" do
    assert Msgunpacker.unpack(<<0x0B>>) == 11
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

  test "should correctly unpack 4,294,967,296" do
    assert Msgunpacker.unpack(<<0xCF, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00>>) ==
             4_294_967_296
  end

  test "should correctly unpack 18,446,744,073,709,551,615" do
    assert Msgunpacker.unpack(<<0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF>>) ==
             18_446_744_073_709_551_615
  end

  test "should correctly unpack -1" do
    assert Msgunpacker.unpack(<<0xFF>>) == -1
  end

  test "should correctly unpack -5" do
    assert Msgunpacker.unpack(<<0xFB>>) == -5
  end

  test "should correctly unpack -27" do
    assert Msgunpacker.unpack(<<0xE5>>) == -27
  end

  test "should correctly unpack -32" do
    assert Msgunpacker.unpack(<<0xE0>>) == -32
  end

  test "should correctly unpack -33" do
    assert Msgunpacker.unpack(<<0xD0, 0xDF>>) == -33
  end

  test "should correctly unpack -127" do
    assert Msgunpacker.unpack(<<0xD0, 0x81>>) == -127
  end

  test "should correctly unpack -128" do
    assert Msgunpacker.unpack(<<0xD1, 0xFF, 0x80>>) == -128
  end

  test "should correctly unpack -32_767" do
    assert Msgunpacker.unpack(<<0xD1, 0x80, 0x01>>) == -32_767
  end

  test "should correctly unpack -32_768" do
    assert Msgunpacker.unpack(<<0xD2, 0xFF, 0xFF, 0x80, 0x00>>) == -32_768
  end

  test "should correctly unpack -2_147_483_647" do
    assert Msgunpacker.unpack(<<0xD2, 0x80, 0x00, 0x00, 0x01>>) == -2_147_483_647
  end

  test "should correctly unpack -2_147_483_648" do
    msg_value = <<0xD3, 0xFF, 0xFF, 0xFF, 0xFF, 0x80, 0x00, 0x00, 0x00>>

    assert Msgunpacker.unpack(msg_value) == -2_147_483_648
  end

  test "should correctly unpack -9_223_372_036_854_775_808" do
    msg_value = <<0xD3, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>

    assert Msgunpacker.unpack(msg_value) == -9_223_372_036_854_775_808
  end

  @doc "Test float"
  test "should unpack float number 123.12" do
    input = <<0xCB, 0x40, 0x5E, 0xC7, 0xAE, 0x14, 0x7A, 0xE1, 0x48>>
    assert Msgunpacker.unpack(input) == 123.12
  end

  test "should unpack float number 123.123123123123" do
    input = <<0xCB, 0x40, 0x5E, 0xC7, 0xE1, 0x3F, 0xCE, 0xCC, 0x75>>
    assert Msgunpacker.unpack(input) == 123.123123123123
  end

  @doc "Test Bitstring pack"
  test "should correctly unpack empty string" do
    assert Msgunpacker.unpack(<<0xA0>>) == ""
  end

  test "should correctly unpack 'Not very long string &'" do
    input = <<0xB6, 0x4E, 0x6F, 0x74, 0x20, 0x76, 0x65, 0x72, 0x79, 0x20, 0x6C, 0x6F, 0x6E, 0x67,
    0x20, 0x73, 0x74, 0x72, 0x69, 0x6E, 0x67, 0x20, 0x26>>

    assert Msgunpacker.unpack(input) == "Not very long string &"
  end

  @doc "Test map"
  test "should unpack simple map - fixedmap" do
    expected = %{
      "compact" => true,
      "schema" => 0
    }

    input =
      <<0x82, 0xA7, 0x63, 0x6F, 0x6D, 0x70, 0x61, 0x63, 0x74, 0xC3, 0xA6, 0x73, 0x63, 0x68, 0x65,
        0x6D, 0x61, 0x00>>

    assert Msgunpacker.unpack(input) == expected
  end

  @doc "Test array"
  test "should unpack fixed array" do
    expected = ["asd", 21, 21]
    l = <<0x93, 0xA3, 0x61, 0x73, 0x64, 0x15, 0x15>>

    assert Msgunpacker.unpack(l) == expected
  end
end
