defmodule MsgunpackerTest do
  use ExUnit.Case
  doctest Msgpacker

  test "should unpack nil" do
    assert Msgunpacker.unpack(<<0xc0>>) == nil
  end
end
