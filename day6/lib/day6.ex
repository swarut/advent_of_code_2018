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

  @doc """
  Generate new coordinates from the given coordinate and distance

  ## Example
      iex> Day6.expand({4, 4}, 1, :top_right)
      [{4, 5}, {5, 4}]
      iex> Day6.expand({4, 4}, 1, :bottom_right)
      [{4, 3}, {5, 4}]
      iex> Day6.expand({4, 4}, 1, :top_left)
      [{3, 4}, {4, 5}]
      iex> Day6.expand({4, 4}, 1, :bottom_left)
      [{3, 4}, {4, 3}]
      iex> Day6.expand({4, 4}, 1)
      [{3, 4}, {4, 3}, {4, 5}, {5, 4}]
  """
  def expand({x, y}, distance, direction) do
    spread_operants(distance, direction) |> Enum.map(fn {x1, y1} -> {x + x1, y + y1} end)
  end
  def expand({x, y}, distance) do
    spread_operants(distance) |> Enum.map(fn {x1, y1} -> {x + x1, y + y1} end)
  end

  @doc """
  Create the map for quick finding of half-distance between each pair of coordinates

  ## Example
      iex>Day6.half_distance_lookup([{1,1}, {4, 4}, {2, 3}])
      %{
        {1, 1} => %{ {1, 1} => 0, {4, 4} => 6, {2, 3} => 3},
        {4, 4} => %{ {1, 1} => 6, {4, 4} => 0, {2, 3} => 3},
        {2, 3} => %{ {1, 1} => 3, {4, 4} => 3, {2, 3} => 0},
      }
  """
  def half_distance_lookup(coordinates) do
    coordinates
    |> Enum.reduce(%{}, fn cod, acc ->
      distance_to_each_cod = Enum.reduce(coordinates, %{}, fn dcod, dacc ->
        dacc |> Map.put(dcod, distance(cod, dcod))
      end)

      Map.put(acc, cod, distance_to_each_cod)
    end)
  end

  @doc """
  Calculate manhattan distance between two coordinates

  ## Example
      iex> Day6.distance({1, 1}, {3, 3})
      4
  """
  def distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def solve do
    # - get edge
    # - for each
    coordinates = get_input("input2.txt")
    look_up = half_distance_lookup(coordinates)
    res = Enum.reduce([1], MapSet.new, fn distance, acc ->
      Enum.reduce(coordinates, MapSet.new, fn cod, racc ->
        new_cods = expand(cod, distance)
        new_cods |> Enum.reduce(racc, fn c, rracc ->
          MapSet.put(rracc, c)
        end)
        |> MapSet.put(cod)
      end)
    end)
  end
end
