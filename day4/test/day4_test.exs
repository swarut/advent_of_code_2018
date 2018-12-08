defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  # test "parse" do
  #   assert Day4.parse(
  #     [
  #       "[1518-11-01 00:00] Guard #10 begins shift"
  #     ]
  #   ) == %{year: 1518, month: 11, day: 1, h: "00", m: "00", action: "begin", guard_id: 10}
  # end

  test "common_time" do
    assert Day4.common_time([
      [1, 2, 3],
      [1, 4, 5]
    ]) === 2

    assert Day4.common_time([
      [2, 3, 5],
      [1, 4, 5]
    ]) === 32

    assert Day4.common_time([
      [2, 3, 5],
      [1, 4, 5, 3]
    ]) === 40

    assert Day4.common_time([
      [2, 3, 5],
      [1, 4, 5, 3],
      []
    ]) === 40
  end
end

# Guard #659 begins shift
# falls asleep
# wakes up
# falls asleep
# falls asleep
