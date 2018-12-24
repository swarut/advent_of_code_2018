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

  def get_boundary(coordinates) do
    min_x = find_min_x(coordinates)
    min_y = find_min_y(coordinates)
    max_x = find_max_x(coordinates)
    max_y = find_max_y(coordinates)
    %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y}
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
      iex> Day6.coordinates_at_distance({4, 4}, 1, :top_right)
      [{4, 5}, {5, 4}]
      iex> Day6.coordinates_at_distance({4, 4}, 1, :bottom_right)
      [{4, 3}, {5, 4}]
      iex> Day6.coordinates_at_distance({4, 4}, 1, :top_left)
      [{3, 4}, {4, 5}]
      iex> Day6.coordinates_at_distance({4, 4}, 1, :bottom_left)
      [{3, 4}, {4, 3}]
      iex> Day6.coordinates_at_distance({4, 4}, 1)
      [{3, 4}, {4, 3}, {4, 5}, {5, 4}]
  """
  def coordinates_at_distance({x, y}, distance, direction) do
    spread_operants(distance, direction) |> Enum.map(fn {x1, y1} -> {x + x1, y + y1} end)
  end
  def coordinates_at_distance({x, y}, distance) do
    spread_operants(distance) |> Enum.map(fn {x1, y1} -> {x + x1, y + y1} end)
  end

  @doc """
  Create the map for quick finding of half-distance between each pair of coordinates

  ## Example
      iex>Day6.half_distance_lookup([{1,1}, {4, 4}, {2, 3}])
      %{
        {1, 1} => %{ {1, 1} => 0, {4, 4} => 3, {2, 3} => 1},
        {4, 4} => %{ {1, 1} => 3, {4, 4} => 0, {2, 3} => 1},
        {2, 3} => %{ {1, 1} => 1, {4, 4} => 1, {2, 3} => 0},
      }
  """
  def half_distance_lookup(coordinates) do
    coordinates
    |> Enum.reduce(%{}, fn cod, acc ->
      distance_to_each_cod = Enum.reduce(coordinates, %{}, fn dcod, dacc ->
        dacc |> Map.put(dcod, div(distance(cod, dcod), 2))
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

  def considerable_coordinates(coordinate, lookup, distance) do
    # IO.puts("\t\tFinding considerable coordinate from #{inspect coordinate}")
    lookup[coordinate]
    |> Enum.reduce([], fn {key, dist}, acc ->
      cond do
        (dist <= distance) && (dist != 0) -> [key] ++ acc
        true -> acc
      end
    end)
  end

  def has_nearer_distance?(cod, other_cods, distance) do
    Enum.any?(other_cods, fn c -> distance(cod, c) <= distance end)
  end

  def expand_coordinates(coordinates, distance) do
    lookup = half_distance_lookup(coordinates)
    Enum.reduce(1..distance, %{}, fn distance, acc ->
      Enum.reduce(coordinates, acc, fn cod, racc ->
        expaned_coordinates = coordinates_at_distance(cod, distance) # Get new coordinates_at_distanceed cods
        considerable_cods = considerable_coordinates(cod, lookup, distance)
        expaned_coordinates |> Enum.reduce(racc, fn c, rracc ->
          cond do
            Map.has_key?(acc, c) -> rracc # Skip it coordinate was taken already
            !has_nearer_distance?(c, considerable_cods, distance) -> Map.put(rracc, c, cod) # Remember coordinate if it is the nearest
            true -> Map.put(rracc, c, "@") # Mark coordinate as '.' if it share common distance
          end
        end)
        |> Map.put(cod, cod)
      end)
    end)
  end

  def solve(input, distance) do
    coordinates = get_input(input)
    boundary = get_boundary(coordinates)

    expand_coordinates(coordinates, distance)
    |> crop(boundary)
    |> print(boundary)
    |> remove_infinite_area(boundary)
  end

  def remove_infinite_area(coordinates_hash, boundary) do
    labels_at_edges = coordinates_hash |> Enum.reduce([], fn {key, value}, acc ->
      case is_on_edge?(boundary, key) do
        true -> [value] ++ acc
        false -> acc
      end
    end)

    coordinates_hash |> Enum.reduce(%{}, fn {key, value}, acc ->
      case Enum.member?(labels_at_edges, value) do
        true -> acc
        false -> Map.put(acc, key, value)
      end
    end)
    |>
    Enum.reduce(%{}, fn {_key, value}, acc ->
      Map.update(acc, value, 1, fn current_value -> current_value + 1 end)
    end)
    |> Enum.max_by(fn {_k, v} -> v end)
  end

  def print(coordinates_hash, boundary) do
    coordinates = Map.keys(coordinates_hash)
    coordinates_hash = labelize(coordinates_hash)

    rows =
      coordinates
      |> Enum.reduce(%{}, fn {x, y}, acc ->
        Map.update(acc, y, [{x, y, coordinates_hash[{x, y}]}], fn current_xs ->
          [{x, y, coordinates_hash[{x,y}]}] ++ current_xs
        end)
      end)
    row_strings =
      boundary.min_y..boundary.max_y
      |> Enum.map(fn row ->
        current_row_xs = (rows[row] || []) |> Enum.uniq() |> Enum.sort()
        boundary.min_x..boundary.max_x |> Enum.to_list |> string_for_row(current_row_xs)
      end)

    File.write("output.txt", row_strings |> Enum.join("\n"))
    coordinates_hash
  end

  def string_for_row(mapper, list_of_x) do
    string_for_row(mapper, list_of_x, [])
  end

  def string_for_row([], _list_of_x = [], acc) do
    acc |> Enum.reverse()
  end

  def string_for_row([row_h | row_t], remainder = [{hx, _hy, hlabel} | t], acc) do
    # IO.puts("compare row_h = #{row_h} and  hx = #{hx}")
    case row_h == hx do
      true -> string_for_row(row_t, t, [hlabel] ++ acc)
      false -> string_for_row(row_t, remainder, ["."] ++ acc)
    end
  end

  def string_for_row([_row_h | row_t], [], acc) do
    string_for_row(row_t, [], ["."] ++ acc)
  end

  def labelize(coordinates_hash) do # Expect the coordinate to be unique, no duplication
    original = coordinates_hash |> Enum.reduce([], fn {_, value}, acc ->
      case value do
        "@" -> acc
        _ -> [value] ++ acc
      end
    end) |> Enum.uniq

    # Create label mapper
    labs = 65..(65 + length(original))
    labels = Enum.zip(original, labs) |> Enum.reduce(%{}, fn {{x, y}, label}, acc ->
      Map.put(acc, {x, y}, label)
    end)


    Enum.reduce(coordinates_hash, %{}, fn {key, val}, acc ->
      value = [labels[val]]
      case value do
        [nil] -> Map.put(acc, key, "@")
        _ -> Map.put(acc, key, value)
      end
    end)
  end

  @doc """
  Remove the coordinate that are out of a given boundary

  ## Example
    iex> Day6.crop(%{{5, 5} => {4, 4}}, %{min_x: 1, max_x: 4, min_y: 1, max_y: 4})
    %{}
    iex> Day6.crop(%{{5, 5} => {4, 4}, {11, 11} => {9, 9}}, %{min_x: 1, max_x: 10, min_y: 1, max_y: 10})
    %{{5, 5} => {4, 4}}
  """
  def crop(coordinates_hash, boundary) do
    Enum.reduce(coordinates_hash, %{}, fn {key, value}, acc ->
      case in_boundary?(boundary, key) do
        true -> Map.put(acc, key, value)
        false -> acc
      end
    end)
  end

  @doc """
  Check wether the given coordinate is inside the boundary or not

  ## Example
      iex> Day6.in_boundary?(%{min_x: 1, max_x: 10, min_y: 1, max_y: 10}, {2, 2})
      true
      iex> Day6.in_boundary?(%{min_x: 1, max_x: 10, min_y: 1, max_y: 10}, {-2, -2})
      false
      iex> Day6.in_boundary?(%{min_x: 1, max_x: 10, min_y: 1, max_y: 10}, {1, 1})
      true
  """
  def in_boundary?(%{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y}, {x, y}) do
    (x >= min_x) && (x <= max_x) && (y >= min_y) && (y <= max_y)
  end

  @doc """
  Check whether the given coordinate is on the edges on not

  ## Example
      iex> Day6.is_on_edge?(%{min_x: 1, max_x: 10, min_y: 1, max_y: 10}, {2, 2})
      false
      iex> Day6.is_on_edge?(%{min_x: 1, max_x: 10, min_y: 1, max_y: 10}, {1, 2})
      true
  """
  def is_on_edge?(%{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y}, {x, y}) do
    (x == min_x) || (x == max_x) || (y == min_y) || (y == max_y)
  end

  def area_within_distance_sum(input, sum) do
    coordinates = get_input(input)
    %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y} = get_boundary(coordinates)
    Enum.reduce(min_x..max_x, 0, fn x, acc ->
      Enum.reduce(min_y..max_y, acc, fn y, racc ->
        s = sum_distance(coordinates, {x, y})
        IO.puts("Sum distance of  (#{x}, #{y}) = #{s} ")
        cond do
          sum_distance(coordinates, {x, y}) < sum -> racc + 1
          true -> racc
        end
      end)
    end)
  end

  def sum_distance(coordinates, target) do
    coordinates |> Enum.reduce(0, fn c, acc ->
      acc + distance(c, target)
    end)
  end
end
