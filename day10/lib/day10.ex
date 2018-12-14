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
      [x, y, vx, vy] =
        String.replace(item, ~r{\s}, "")
        |> String.split(["position=<", ",", ">velocity=<", ",", ">"], trim: true)

      %{
        x: String.to_integer(x),
        y: String.to_integer(y),
        vx: String.to_integer(vx),
        vy: String.to_integer(vy)
      }
    end)
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
  Find current boundary

  ## Example
      iex> Day10.calculate_current_boundary([
      ...> %{x: 10, y: 1},
      ...> %{x: 9, y: 10},
      ...> %{x: -1, y: 11},
      ...> %{x: 14, y: -1}
      ...> ])
      180
  """
  def calculate_current_boundary(coordinate) do
    width = find_max_x(coordinate) - find_min_x(coordinate)
    height = find_max_y(coordinate) - find_min_y(coordinate)
    width * height
  end

  @doc """
  Translate to the new position according to the given time then return the new coordinates

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
  def translate(dots, second) do
    dots
    |> Enum.map(fn dot ->
      %{x: dot.x + second * dot.vx, y: dot.y + second * dot.vy}
    end)
  end

  @doc """
  Get the list of dots, then try to find the number of second that
  the boundary

  ## Example
      iex> Day10.solve([
      ...>%{x: 9, y:  1, vx: 0, vy:  2},
      ...>%{x: 7, y:  0, vx: -1, vy:  0},
      ...>%{x: 3, y: -2, vx: -1, vy:  1},
      ...>%{x: 6, y: 10, vx: -2, vy: -1},
      ...>%{x: 2, y: -4, vx: 2, vy:  2},
      ...>%{x: -6, y: 10, vx: 2, vy: -2},
      ...>%{x: 1, y:  8, vx: 1, vy: -1},
      ...>%{x: 1, y:  7, vx: 1, vy:  0},
      ...>%{x: -3, y: 11, vx: 1, vy: -2},
      ...>%{x: 7, y:  6, vx: -1, vy: -1},
      ...>%{x: -2, y:  3, vx: 1, vy:  0},
      ...>%{x: -4, y:  3, vx: 2, vy:  0},
      ...>%{x: 10, y: -3, vx: -1, vy:  1},
      ...>%{x: 5, y: 11, vx: 1, vy: -2},
      ...>%{x: 4, y:  7, vx: 0, vy: -1},
      ...>%{x: 8, y: -2, vx: 0, vy:  1},
      ...>%{x: 15, y:  0, vx: -2, vy:  0},
      ...>%{x: 1, y:  6, vx: 1, vy:  0},
      ...>%{x: 8, y:  9, vx: 0, vy: -1},
      ...>%{x: 3, y:  3, vx: -1, vy:  1},
      ...>%{x: 0, y:  5, vx: 0, vy: -1},
      ...>%{x: -2, y:  2, vx: 2, vy:  0},
      ...>%{x: 5, y: -2, vx: 1, vy:  2},
      ...>%{x: 1, y:  4, vx: 2, vy:  1},
      ...>%{x: -2, y:  7, vx: 2, vy: -2},
      ...>%{x: 3, y:  6, vx: -1, vy: -1},
      ...>%{x: 5, y:  0, vx: 1, vy:  0},
      ...>%{x: -6, y:  0, vx: 2, vy:  0},
      ...>%{x: 5, y:  9, vx: 1, vy: -2},
      ...>%{x: 14, y:  7, vx: -2, vy:  0},
      ...>%{x: -3, y:  6, vx: 2, vy: -1},
      ...>])
      3
  """
  def solve(dots) do
    (dots |> iterate).answer
  end

  def iterate(dots) do
    iterate(dots, 0, [])
  end

  def iterate(
        dots,
        second,
        acc = %{previous_boundary: previous_boundary, previous_second: previous_second}
      ) do
    translated_coordinates = translate(dots, second)
    current_boundary = calculate_current_boundary(translated_coordinates)
    IO.puts("SECOND: #{second}")
    IO.puts("boundary movement: #{boundary_movement(previous_boundary, current_boundary)}")

    cond do
      previous_boundary - current_boundary > 0 ->
        next_second = second + 1
        new_acc =
          acc
          |> Map.put(:previous_boundary, current_boundary)
          |> Map.put(:previous_second, second)

        iterate(dots, next_second, new_acc)

      previous_boundary - current_boundary < 0 ->
        %{answer: previous_second, second: second, previous_second: previous_second}
    end
  end

  def iterate(dots, second, []) do
    translated_coordinates = translate(dots, second)
    current_boundary = calculate_current_boundary(translated_coordinates)
    next_second = second + 1
    iterate(dots, next_second, %{previous_boundary: current_boundary, previous_second: second})
  end

  def get_dots do
    get_input("input.txt") |> parse_input
  end

  def boundary_movement(prev, next) do
    cond do
      prev - next < 0 -> "Expand"
      prev - next > 0 -> "Shrink"
    end
  end

  def print(coordinates) do
    min_x = find_min_x(coordinates)
    min_y = find_min_y(coordinates)

    normalized_coordinates =
      coordinates
      |> Enum.map(fn %{x: x, y: y} ->
        %{x: x - min_x, y: y - min_y}
      end)

    min_x = find_min_x(normalized_coordinates)
    min_y = find_min_y(normalized_coordinates)
    max_x = find_max_x(normalized_coordinates)
    max_y = find_max_y(normalized_coordinates)
    width = max_x - min_x
    height = max_y - min_y

    rows =
      normalized_coordinates
      |> Enum.reduce(%{}, fn %{x: x, y: y}, acc ->
        Map.update(acc, y, [x], fn current_xs ->
          [x] ++ current_xs
        end)
      end)

    row_strings =
      0..height
      |> Enum.map(fn row ->
        current_row_xs = rows[row] |> Enum.uniq() |> Enum.sort()
        0..width |> Enum.to_list() |> string_for_row(current_row_xs)
      end)

    File.write("output.txt", row_strings |> Enum.join("\n"))
  end

  def print_second(dots, second) do
    translate(dots, second) |> print
  end

  @doc """
  Create string for row. With speicified x, fill in with "#", else fill ".".

  ## Example
      iex> Day10.string_for_row(Enum.to_list(0..3), [1, 2], [])
      [".", "#", "#", "."]
  """
  def string_for_row([], list_of_x) do
    string_for_row([], list_of_x, [])
  end

  def string_for_row([], list_of_x = [], acc) do
    acc |> Enum.reverse()
  end

  def string_for_row([row_h | row_t], remainder = [h | t], acc) do
    acc =
      case row_h == h do
        true -> string_for_row(row_t, t, ["#"] ++ acc)
        false -> string_for_row(row_t, remainder, ["."] ++ acc)
      end
  end

  def string_for_row([row_h | row_t], [], acc) do
    string_for_row(row_t, [], ["."] ++ acc)
  end
end
