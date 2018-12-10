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

      iex> Day5.solve('dabAcCaCBAcCcaDA')
      10
      iex> Day5.solve('dab')
      3

  """
  def solve(units) do
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
    processed_units
  end

end
