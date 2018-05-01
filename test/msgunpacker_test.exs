defmodule MsgunpackerTest do
  use ExUnit.Case
  doctest Msgpacker

  test "should unpack nil" do
    assert Msgunpacker.unpack([0xc0]) == nil
  end

  test "should unpack true" do
    assert Msgunpacker.unpack([0xc3]) == true
  end

  test "should unpack false" do
    assert Msgunpacker.unpack([0xc2]) == false
  end
end
