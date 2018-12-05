defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "parse" do
    assert Day4.parse(
      [
        "[1518-11-01 00:00] Guard #10 begins shift"
      ]
    ) == %{year: 1518, month: 11, day: 1, h: "00", m: "00", action: "begin", guard_id: 10}
  end

  test "parse_date" do
    assert Day4.parse_date()
  end

  test "parse_action" do
  end
end

# Guard #659 begins shift
# falls asleep
# wakes up
# falls asleep
# falls asleep
