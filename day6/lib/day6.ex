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
    IO.puts("\t\tFinding considerable coordinate from #{inspect coordinate}")
    lookup[coordinate]
    |> Enum.reduce([], fn {key, dist}, acc ->
      cond do
        (dist <= distance) && (dist != 0) -> [key] ++ acc
        true -> acc
      end
    end)
  end

  @spec is_nearest?(any(), any(), any()) :: boolean()
  def is_nearest?(_cod, [], _distance) do
    IO.puts("\t\tNo considerable coordinates")
    true
  end
  def has_nearer_distance?(cod, other_cods, distance) do
    IO.puts("\t\tCHECKING if #{inspect cod} is close to any of #{inspect other_cods} within #{distance}.")

    Enum.any?(other_cods, fn c ->
      IO.puts("\t\t----- distance between #{inspect cod} and #{inspect c} is #{distance(cod, c)}")
      distance(cod, c) <= distance
    end)
  end


  def solve(input, distance) do
    coordinates = get_input(input)
    lookup = half_distance_lookup(coordinates)
    Enum.reduce(1..distance, %{}, fn distance, acc ->
      # Find coordinates after expanding for distance
      Enum.reduce(coordinates, acc, fn cod, racc ->
        new_cods = expand(cod, distance) # Get new expanded cods
        IO.puts("PROCESSING DISTANCE = #{distance}, for cod = #{inspect cod} :::  new coordinates = #{inspect new_cods}")
        considerable_cods = considerable_coordinates(cod, lookup, distance)
        new_cods |> Enum.reduce(racc, fn c, rracc ->
          # Pick new expanded cod only if it is the nearest to target cod
          cond do
            Map.has_key?(acc, c) -> rracc # Skip it coordinate was taken already
            !has_nearer_distance?(c, considerable_cods, distance) -> Map.put(rracc, c, cod) # Remember coordinate if it is the nearest
            true -> Map.put(rracc, c, ".") # Mark coordinate as '.' if it share common distance
          end
        end)
        |> Map.put(cod, cod)
      end)

      # MapSet.union(acc, all_coordinates)
    end)
  end

  def print(coordinates_hash) do
    coordinates = Map.keys(coordinates_hash)
    min_x = find_min_x(coordinates)
    min_y = find_min_y(coordinates)

    # normalized_coordinates =
    #   coordinates
    #   |> Enum.map(fn {x, y} ->
    #     {x - min_x, y - min_y}
    #   end)
    min_x = find_min_x(coordinates)
    min_y = find_min_y(coordinates)
    max_x = find_max_x(coordinates)
    max_y = find_max_y(coordinates)
    # width = max_x - min_x
    # height = max_y - min_y
    width = max_x
    height = max_y

    coordinates_hash = labelize(coordinates_hash)

    rows =
      coordinates
      |> Enum.reduce(%{}, fn {x, y}, acc ->
        Map.update(acc, y, [{x, y, coordinates_hash[{x, y}]}], fn current_xs ->
          [{x, y, coordinates_hash[{x,y}]}] ++ current_xs
        end)
      end)
    IO.puts("row --------- #{inspect rows}")
    row_strings =
      min_y..height
      |> Enum.map(fn row ->
        IO.puts("ROW NUMBER #{row}")
        current_row_xs = (rows[row] || []) |> Enum.uniq() |> Enum.sort()
        IO.puts("current row xs #{inspect current_row_xs}")
        min_x..width |> Enum.to_list() |> string_for_row(current_row_xs)
      end)

    File.write("output.txt", row_strings |> Enum.join("\n"))
  end

  def string_for_row(mapper, list_of_x) do
    string_for_row(mapper, list_of_x, [])
  end

  def string_for_row([], _list_of_x = [], acc) do
    acc |> Enum.reverse()
  end

  def string_for_row([row_h | row_t], remainder = [{hx, _hy, hlabel} | t], acc) do
    case row_h == hx do
      true -> string_for_row(row_t, t, [hlabel] ++ acc)
      false -> string_for_row(row_t, remainder, ["o"] ++ acc)
    end
  end

  def string_for_row([_row_h | row_t], [], acc) do
    string_for_row(row_t, [], ["o"] ++ acc)
  end

  def labelize(coordinates_hash) do # Expect the coordinate to be unique, no duplication
    # original = coordinates_hash |> Enum.map(fn {_, value} -> value end) |> Enum.uniq
    original = coordinates_hash |> Enum.reduce([], fn {_, value}, acc ->
      case value do
        "." -> acc
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
        [nil] -> Map.put(acc, key, ".")
        _ -> Map.put(acc, key, value)
      end
    end)
  end
end
