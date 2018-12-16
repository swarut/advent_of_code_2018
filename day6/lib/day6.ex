defmodule Day6 do
  @moduledoc """
  Documentation for Day6.
  """

  @doc """
  Get input

  ## Examples

      iex> Day6.get_input("input2.txt")
      [
        %{x: 1, y: 1},
        %{x: 1, y: 6},
        %{x: 8, y: 3},
        %{x: 3, y: 4},
        %{x: 5, y: 5},
        %{x: 8, y: 9}
      ]
  """
  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true)
    |> Enum.map(fn co ->
      [x, y] = co |> String.split(",", trim: true)
      %{x: String.to_integer(x), y: String.to_integer(y)}
    end)
  end

  @doc """
  Find max x

  ## Example
      iex> Day6.find_max_x([
      ...> %{x: 10, y: 1},
      ...> %{x: 9, y: 10}
      ...> ])
      10
  """
  def find_max_x(coordinates) do
    Enum.max_by(coordinates, fn cod -> cod.x end).x
  end

  @doc """
  Find max y

  ## Example
      iex> Day6.find_max_y([
      ...> %{x: 10, y: 1},
      ...> %{x: 9, y: 10}
      ...> ])
      10
  """
  def find_max_y(coordinates) do
    Enum.max_by(coordinates, fn cod -> cod.y end).y
  end

  @doc """
  Find min x

  ## Example
      iex> Day6.find_min_x([
      ...> %{x: 10, y: 1},
      ...> %{x: 9, y: 10}
      ...> ])
      9
  """
  def find_min_x(coordinates) do
    Enum.min_by(coordinates, fn cod -> cod.x end).x
  end

  @doc """
  Find min y

  ## Example
      iex> Day6.find_min_y([
      ...> %{x: 10, y: 1},
      ...> %{x: 9, y: 10}
      ...> ])
      1
  """
  def find_min_y(coordinates) do
    Enum.min_by(coordinates, fn cod -> cod.y end).y
  end

  @doc """
  Return operant coordinates that can be used to find surrounding coordinates
  of a given coordinate

  ## Example
      iex> Day6.spread_operants(2, :top_left)
      MapSet.new([%{x: -2, y: 0}, %{x: -1, y: 1}, %{x: 0, y: 2}])
  """
  # iex> Day6.spread_operants(1)
  #     [ %{x: -1, y: 0}, %{x: 0, y: 1}, %{x: 1, y: 0}, %{x: 0, y: -1}, %{x: -1, y: -1}]
  def spread_operants(distance, :top_left) do
    coordinates_from_ranges(-distance..0, 0..distance)
  end

  @doc """
  Generate coordinates from the given ranges

  ## Example
      iex> Day6.coordinates_from_ranges(1..2, 3..4)
      MapSet.new([%{x: 1, y: 3}, %{x: 2, y: 4}])
  """
  def coordinates_from_ranges(x_range, y_range) do
    Enum.zip(x_range, y_range)
    |> Enum.reduce(MapSet.new, fn {x, y}, acc ->
      MapSet.put(acc, %{x: x, y: y})
    end)
  end

  def solve do
    # - get edge
    # - for each
  end
end
