defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "get_spec" do
    assert Day3.get_spec("#1 @ 1,3: 4x4") == ["1,3:", "4x4"]
  end

  test "map_claim" do
    assert Day3.map_claim(["1,3:", "4x4"]) == %Claim{left: 1, top: 3, wide: 4, tall: 4, start_x: 1, end_x: 5, start_y: 3, end_y: 7}
  end

  test "get_input" do
    assert Day3.get_input("input2.txt") == [
      %Claim{left: 1, top: 3, wide: 4, tall: 4, start_x: 1, end_x: 5, start_y: 3, end_y: 7},
      %Claim{left: 3, top: 1, wide: 4, tall: 4, start_x: 3, end_x: 7, start_y: 1, end_y: 5},
      %Claim{left: 5, top: 5, wide: 2, tall: 2, start_x: 5, end_x: 7, start_y: 5, end_y: 7}
    ]
  end

  test "compute_overlapped" do
    claim1 = %Claim{left: 1, top: 3, wide: 4, tall: 4, start_x: 1, end_x: 5, start_y: 3, end_y: 7}
    claim2 = %Claim{left: 3, top: 1, wide: 4, tall: 4, start_x: 3, end_x: 7, start_y: 1, end_y: 5}
    assert Day3.compute_overlapped(claim1, claim2) == 4
  end

  test "solve" do
    assert Day3.solve() == 4
  end

end
