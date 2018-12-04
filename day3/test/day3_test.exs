defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "get_spec" do
    assert Day3.get_spec("#1 @ 1,3: 4x4") == ["1,3:", "4x4"]
  end

  test "map_claim" do
    assert Day3.map_claim(["1,3:", "4x4"]) == %Claim{left: 1, top: 3, wide: 4, tall: 4}
  end

  test "get_input" do
    assert Day3.get_input("input2.txt") == [
      %Claim{left: 1, top: 3, wide: 4, tall: 4},
      %Claim{left: 3, top: 1, wide: 4, tall: 4},
      %Claim{left: 5, top: 5, wide: 2, tall: 2}
    ]
  end

end
