defmodule Day10 do
  @moduledoc """
  Documentation for Day10.
  """

  @doc """
  Get input

  ## Examples

      iex> Day10.get_input("input2.txt")
      [
        "position=\< 9,  1\> velocity=\< 0,  2\>",
        "position=\< 7,  0\> velocity=\<-1,  0\>",
        "position=\< 3, -2\> velocity=\<-1,  1\>",
        "position=\< 6, 10\> velocity=\<-2, -1\>",
        "position=\< 2, -4\> velocity=\< 2,  2\>",
        "position=\<-6, 10\> velocity=\< 2, -2\>",
        "position=\< 1,  8\> velocity=\< 1, -1\>",
        "position=\< 1,  7\> velocity=\< 1,  0\>",
        "position=\<-3, 11\> velocity=\< 1, -2\>",
        "position=\< 7,  6\> velocity=\<-1, -1\>",
        "position=\<-2,  3\> velocity=\< 1,  0\>",
        "position=\<-4,  3\> velocity=\< 2,  0\>",
        "position=\<10, -3\> velocity=\<-1,  1\>",
        "position=\< 5, 11\> velocity=\< 1, -2\>",
        "position=\< 4,  7\> velocity=\< 0, -1\>",
        "position=\< 8, -2\> velocity=\< 0,  1\>",
        "position=\<15,  0\> velocity=\<-2,  0\>",
        "position=\< 1,  6\> velocity=\< 1,  0\>",
        "position=\< 8,  9\> velocity=\< 0, -1\>",
        "position=\< 3,  3\> velocity=\<-1,  1\>",
        "position=\< 0,  5\> velocity=\< 0, -1\>",
        "position=\<-2,  2\> velocity=\< 2,  0\>",
        "position=\< 5, -2\> velocity=\< 1,  2\>",
        "position=\< 1,  4\> velocity=\< 2,  1\>",
        "position=\<-2,  7\> velocity=\< 2, -2\>",
        "position=\< 3,  6\> velocity=\<-1, -1\>",
        "position=\< 5,  0\> velocity=\< 1,  0\>",
        "position=\<-6,  0\> velocity=\< 2,  0\>",
        "position=\< 5,  9\> velocity=\< 1, -2\>",
        "position=\<14,  7\> velocity=\<-2,  0\>",
        "position=\<-3,  6\> velocity=\< 2, -1\>"
      ]
  """
  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true)
  end

  @doc """
  Parse input

  ## Example
      iex> Day10.parse_input(["position=\<-3,  6\> velocity=\< 2, -1\>"])
      [%{x: -3, y: 6, vx: 2, vy: -1}]

      iex> Day10.parse_input(["position=\< 5,  9\> velocity=\< 1, -2\>",])
      [%{x: 5, y: 9, vx: 1, vy: -2}]
  """
  def parse_input(list) do
    list
    |> Enum.map(fn item ->
      [x, y, vx, vy] = String.replace(item, ~r{\s}, "") |> String.split(["position=<", ",",  ">velocity=<", ",", ">"], trim: true)
      %{x: String.to_integer(x), y: String.to_integer(y), vx: String.to_integer(vx), vy: String.to_integer(vy)}
    end)
  end

  @doc """
  Inject IDs to the dots so that we can refer to each dot later

  ## Example
      iex> Day10.inject_id([
      ...> %{x: 10, y: 1, vx: 1, vy: 1},
      ...> %{x: 9, y: 10, vx: 1, vy: 1},
      ...> %{x: -1, y: 11, vx: 1, vy: 1},
      ...> %{x: 14, y: -1, vx: 1, vy: 1}
      ...> ])
      [
        %{x: 10, y: 1, vx: 1, vy: 1, id: 0},
        %{x: 9, y: 10, vx: 1, vy: 1, id: 1},
        %{x: -1, y: 11, vx: 1, vy: 1, id: 2},
        %{x: 14, y: -1, vx: 1, vy: 1, id: 3}
      ]
  """
  def inject_id(dots) do
    # NOTE: Can be improved with MapSet, so that reverse at the end is not needed
    result = dots |> Enum.reduce(%{counter: 0, result: []}, fn dot, acc = %{counter: counter, result: result} ->
      acc
      |> Map.put(:result, [Map.put(dot, :id, counter)] ++ result)
      |> Map.put(:counter, counter + 1)
    end)

    result[:result] |> Enum.reverse
  end

  @doc """
  Find max x

  ## Example
      iex> Day10.find_max_x([
      ...> %{x: 10, y: 1, vx: 1, vy: 1},
      ...> %{x: 9, y: 10, vx: 1, vy: 1},
      ...> %{x: -1, y: 11, vx: 1, vy: 1},
      ...> %{x: 14, y: -1, vx: 1, vy: 1}
      ...> ])
      14
  """
  def find_max_x(list) do
    Enum.max_by(list, fn dot -> dot.x end).x
  end

  @doc """
  Find max y

  ## Example
      iex> Day10.find_max_y([
      ...> %{x: 10, y: 1, vx: 1, vy: 1},
      ...> %{x: 9, y: 10, vx: 1, vy: 1},
      ...> %{x: -1, y: 11, vx: 1, vy: 1},
      ...> %{x: 14, y: -1, vx: 1, vy: 1}
      ...> ])
      11
  """
  def find_max_y(dots) do
    Enum.max_by(dots, fn dot -> dot.y end).y
  end

  @doc """
  Find min x

  ## Example
      iex> Day10.find_min_x([
      ...> %{x: 10, y: 1, vx: 1, vy: 1},
      ...> %{x: 9, y: 10, vx: 1, vy: 1},
      ...> %{x: -1, y: 11, vx: 1, vy: 1},
      ...> %{x: 14, y: -1, vx: 1, vy: 1}
      ...> ])
      -1
  """
  def find_min_x(list) do
    Enum.min_by(list, fn dot -> dot.x end).x
  end

  @doc """
  Find min y

  ## Example
      iex> Day10.find_min_y([
      ...> %{x: 10, y: 1, vx: 1, vy: 1},
      ...> %{x: 9, y: 10, vx: 1, vy: 1},
      ...> %{x: -1, y: 11, vx: 1, vy: 1},
      ...> %{x: 14, y: -1, vx: 1, vy: 1}
      ...> ])
      -1
  """
  def find_min_y(dots) do
    Enum.min_by(dots, fn dot -> dot.y end).y
  end

  @doc """
  Find leftmost horizontal edge

  ## Example
      iex> Day10.leftmost_horizontal_edge([
      ...> %{x: 10, y: 1, vx: 1, vy: 1},
      ...> %{x: 9, y: 10, vx: 1, vy: 1},
      ...> %{x: -1, y: 11, vx: 1, vy: 1},
      ...> %{x: 14, y: -1, vx: 1, vy: 1}
      ...> ])

  """

  @doc """
  Translate to the new position according to the given time

  ## Example
      iex> Day10.translate([
      ...> %{x: 10, y: 1, vx: -3, vy: 1},
      ...> %{x: 9, y: 10, vx: 2, vy: 1},
      ...> %{x: -1, y: 11, vx: 3, vy: -1},
      ...> %{x: 14, y: -1, vx: -1, vy: 2}
      ...> ], 1)
      [
        %{x: 7, y: 2},
        %{x: 11, y: 11},
        %{x: 2, y: 10},
        %{x: 13, y: 1}
      ]
      iex> Day10.translate([
      ...> %{x: 10, y: 1, vx: -3, vy: 1},
      ...> %{x: 9, y: 10, vx: 2, vy: 1},
      ...> %{x: -1, y: 11, vx: 3, vy: -1},
      ...> %{x: 14, y: -1, vx: -1, vy: 2}
      ...> ], 4)
      [
        %{x: -2, y: 5},
        %{x: 17, y: 14},
        %{x: 11, y: 7},
        %{x: 10, y: 7}
      ]
  """
  def translate(dots, seconds) do
    dots |> Enum.map( fn dot ->
      %{x: dot.x + (seconds * dot.vx), y: dot.y + (seconds * dot.vy)}
    end)
  end

  # @doc """
  # Get the list of dots, then try to find the maximum number of second that
  # the min/max x and min/max y are not change after translation.

  # ## Example
  #     iex> Day10.solve([
  #     ...> %{x: 1, y: 1, vx: 1, vy: 1},
  #     ...> %{x: 10, y: 10, vx: -2, vy: -2},
  #     ...> ])
  # """
  # def part1_solve() do

  # end

end

# Slowest movement should be at the edge
