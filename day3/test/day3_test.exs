defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "get_spec" do
    assert Day3.get_spec("#1 @ 1,3: 4x4") == [1, 1, 3, 4, 4]
  end

  test "map_claim" do
    assert Day3.map_claim([1, 1, 3, 4, 4]) == %Claim{left: 1, top: 3, wide: 4, tall: 4, start_x: 1, end_x: 5, start_y: 3, end_y: 7}
  end
end
