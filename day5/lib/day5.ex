defmodule Day5 do
  @moduledoc """
  Documentation for Day5.
  """

  @doc """
  Get input

  ## Examples

      iex> Day5.get_input("input2.txt")
      ['dabAcCaCBAcCcaDA']

  """
  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true)
    |> Enum.map(fn line -> String.to_charlist(line) end)
  end

  @doc """
  Check whether two input have the opposite polarity or not. Expect input to be codepoint

  ## Examples
      iex> Day5.opposite_polar?(65, 97)
      true
      iex> Day5.opposite_polar?(65, 98)
      false
  """
  def opposite_polar?(a, b) do
    abs(a - b) == 32
  end

  @doc """
  Get the number of existing unit

      iex> Day5.part1_solve('dabAcCaCBAcCcaDA')
      10
      iex> Day5.part1_solve('dab')
      3

  """
  def part1_solve(units) do
    process_units(units) |> length
  end

  @doc """
  Read unit one by one and remove if a pair of unit contain opposite polarity.

  ## Examples
      iex> Day5.process_units('AaB')
      'B'
  """
  def process_units(units) do
    process_units(units, [])
  end

  def process_units([unit | rest], processed_units = [recent_processed_unit | rest_of_processed_units]) do
    case opposite_polar?(unit, recent_processed_unit) do
      true -> process_units(rest, rest_of_processed_units)
      false -> process_units(rest, [unit] ++ processed_units)
    end
  end

  def process_units([unit | rest], []) do
    process_units(rest, [unit])
  end

  def process_units([], processed_units) do
    processed_units |> Enum.reverse
  end

  @doc """
  Get the minimum count of existing unit given that a specific pair of palar is removed

  ## Examples
      iex> Day5.part2_solve('dabAcCaCBAcCcaDA')
      4
  """
  def part2_solve(units) do
    [?A, ?B, ?C, ?D, ?E, ?F, ?G, ?H, ?I, ?J, ?K, ?L, ?M, ?N, ?O, ?P, ?Q, ?R, ?S, ?T, ?U, ?V, ?W, ?X, ?Y, ?Z]
    |> Enum.map(fn char ->
      process_units_with_ignored_chars(units, char) |> length
    end)
    |> Enum.min
  end

  @doc """
  Return opposite polar of a given unit

  ## Example
      iex> Day5.get_opposite_polar(97)
      65
      iex> Day5.get_opposite_polar(65)
      97
  """
  def get_opposite_polar(unit) do
    cond do
      unit - 97 >= 0 -> unit - 32
      true -> unit + 32
    end
  end

  @doc """
  Read unit one by one and remove if a pair of unit contain opposite polarity, also ignore the given chars.

  ## Example
      iex> Day5.process_units_with_ignored_chars('dabAcCaCBAcCcaDA', ?a)
      'dbCBcD'
  """
  def process_units_with_ignored_chars(units, char) do
    process_units_with_ignored_chars(units, char, [])
  end

  def process_units_with_ignored_chars([unit | rest], char, processed_units = [recent_processed_unit | rest_of_processed_units]) do
    opposite = get_opposite_polar(char)
    cond do
      unit == char || unit == get_opposite_polar(char) ->
        process_units_with_ignored_chars(rest, char, processed_units)
      true ->
        case opposite_polar?(unit, recent_processed_unit) do
          true -> process_units_with_ignored_chars(rest, char, rest_of_processed_units)
          false -> process_units_with_ignored_chars(rest, char, [unit] ++ processed_units)
        end
    end
  end

  def process_units_with_ignored_chars([unit | rest], char, []) do
    cond do
      unit == char || unit == get_opposite_polar(char) ->
        process_units_with_ignored_chars(rest, char, [])
      true ->
        process_units_with_ignored_chars(rest, char, [unit])
    end
  end

  def process_units_with_ignored_chars([], _char, processed_units) do
    processed_units |> Enum.reverse
  end

end
