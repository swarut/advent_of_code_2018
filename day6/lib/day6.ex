defmodule Day6 do
  @moduledoc """
  Documentation for Day6.
  """

  @doc """
  Get input

  ## Examples

      iex> Day6.get_input("input2.txt")
      [
        {1, 1},
        {1, 6},
        {8, 3},
        {3, 4},
        {5, 5},
        {8, 9}
      ]
  """
  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true)
    |> Enum.map(fn co ->
      [x, y] = co |> String.split(",", trim: true)
      {String.to_integer(x), String.to_integer(y)}
    end)
  end

  @doc """
  Find max x

  ## Example
      iex> Day6.find_max_x([
      ...> {10, 1},
      ...> {9, 10}
      ...> ])
      10
  """
  def find_max_x(coordinates) do
    {max, _} = Enum.max_by(coordinates, fn {x, _y} -> x end)
    max
  end

  @doc """
  Find max y

  ## Example
      iex> Day6.find_max_y([
      ...> {10, 1},
      ...> {9, 10}
      ...> ])
      10
  """
  def find_max_y(coordinates) do
    {_, max} = Enum.max_by(coordinates, fn {_x, y} -> y end)
    max
  end

  @doc """
  Find min x

  ## Example
      iex> Day6.find_min_x([
      ...> {10, 1},
      ...> {9, 10}
      ...> ])
      9
  """
  def find_min_x(coordinates) do
    {min, _} = Enum.min_by(coordinates, fn {x, _y} -> x end)
    min
  end

  @doc """
  Find min y

  ## Example
      iex> Day6.find_min_y([
      ...> {10, 1},
      ...> {9, 10}
      ...> ])
      1
  """
  def find_min_y(coordinates) do
    {_, min} = Enum.min_by(coordinates, fn {_x, y} -> y end)
    min
  end

  @doc """
  Return operant coordinates that can be used to find surrounding coordinates
  of a given coordinate

  ## Example
      iex> Day6.spread_operants(2, :top_left)
      MapSet.new([{-2, 0}, {-1, 1}, {0, 2}])
      iex> Day6.spread_operants(2, :top_right)
      MapSet.new([{0, 2}, {1, 1}, {2, 0}])
      iex> Day6.spread_operants(2, :bottom_left)
      MapSet.new([{-2, 0}, {-1, -1}, {0, -2}])
      iex> Day6.spread_operants(2, :bottom_right)
      MapSet.new([{0, -2}, {1, -1}, {2, 0}])
      iex> Day6.spread_operants(2, :top)
      MapSet.new([{-2, 0}, {-1, 1}, {0, 2}, {1, 1}, {2, 0}])
      iex> Day6.spread_operants(2, :bottom)
      MapSet.new([{-2, 0}, {-1, -1}, {0, -2}, {1, -1}, {2, 0}])
      iex> Day6.spread_operants(2)
      MapSet.new([{-2, 0}, {-1, -1}, {0, 2}, {1, 1}, {2, 0}, {1, -1}, {0, -2}, {-1, -1}, {-1, 1}])
  """
  # iex> Day6.spread_operants(1)
  #     [ {-1, 0}, {0, 1}, {1, 0}, {0, -1}, {-1, -1}]
  def spread_operants(distance, :top_left) do
    coordinates_from_ranges(-distance..0, 0..distance)
  end
  def spread_operants(distance, :bottom_left) do
    coordinates_from_ranges(-distance..0, 0..-distance)
  end
  def spread_operants(distance, :top_right) do
    coordinates_from_ranges(0..distance, distance..0)
  end
  def spread_operants(distance, :bottom_right) do
    coordinates_from_ranges(0..distance, -distance..0)
  end
  def spread_operants(distance, :top) do
    MapSet.union(spread_operants(distance, :top_left), spread_operants(distance, :top_right))
  end
  def spread_operants(distance, :bottom) do
    MapSet.union(spread_operants(distance, :bottom_left), spread_operants(distance, :bottom_right))
  end
  def spread_operants(distance) do
    MapSet.union(spread_operants(distance, :top), spread_operants(distance, :bottom))
  end


  @doc """
  Generate coordinates from the given ranges

  ## Example
      iex> Day6.coordinates_from_ranges(1..2, 3..4)
      MapSet.new([{1, 3}, {2, 4}])
  """
  def coordinates_from_ranges(x_range, y_range) do
    Enum.zip(x_range, y_range)
    |> Enum.reduce(MapSet.new, fn {x, y}, acc ->
      MapSet.put(acc, {x, y})
    end)
  end

  def solve do
    # - get edge
    # - for each
  end
end
