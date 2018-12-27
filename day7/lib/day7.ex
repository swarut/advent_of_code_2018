defmodule Day7 do
  def get_input(filename) do
    {:ok, result} = File.read(filename)

    String.split(result, "\n", trim: true)
    |> Enum.map(fn co ->
      [x, y] =
        co |> String.split(["Step ", " must be finished before step ", " can begin."], trim: true)

      {x, y}
    end)
    |> Enum.sort
  end

  @doc """
  Find start point and end point

  ## Example
      iex> Day7.find_start_and_end_points([{"A", "B"}, {"A", "C"}, {"B", "D"}, {"C", "D"}])
      {["A"], ["D"]}
  """
  def find_start_and_end_points(tuples) do
    {elements_at_first_position, elements_at_second_position} =
      tuples
      |> Enum.reduce({[], []}, fn {a, b}, {a_col, b_col} ->
        {([a] ++ a_col) |> Enum.uniq(), ([b] ++ b_col) |> Enum.uniq()}
      end)

    {(elements_at_first_position -- elements_at_second_position) |> Enum.reverse,
     (elements_at_second_position -- elements_at_first_position) |> Enum.reverse}
  end

  @doc """
  Process the given tuples

  ## Example
      iex> Day7.proceed([{"A", "B"}, {"A", "C"}, {"B", "D"}, {"C", "D"}])
      "ABCD"
      iex> Day7.proceed([{"A", "B"}, {"B", "C"}, {"D", "B"}])
      "ADBC"
      iex> Day7.proceed([{"M", "D"}, {"X", "Y"}, {"Y", "D"}])
      "MXYD"
      iex> Day7.proceed([{"A", "B"},{"B", "C"},{"B", "E"},{"C", "Z"},{"D", "B"},{"E", "Z"}])
      "ADBCEZ"
      iex> Day7.proceed([{"A", "B"},{"A", "C"},{"A", "D"},{"B", "E"},{"B", "X"},{"C", "E"},{"D", "E"},{"E", "Z"},{"X", "Z"}])
      "ABCDEXZ"
      iex> Day7.proceed([{"A", "B"},{"A", "C"},{"A", "X"},{"B", "D"},{"B", "E"},{"C", "E"},{"D", "Z"},{"E", "Z"},{"X", "E"}])
      "ABCDXEZ"
  """
  def proceed(tuples) do
    # figure out the fisrt element
    {[first | _], _} = find_start_and_end_points(tuples)
    proceed(tuples, [first], [first])
  end

  def proceed([], cursor, acc) do
    IO.puts(" PROCEED tuples = [], cursor = #{inspect cursor}, acc = #{inspect acc, limit: :infinity}")
    finalize_output(acc)
  end

  def proceed(tuples, [head_of_cursor | rest_of_cursor] = cursor, acc) do
    IO.puts(" PROCEED tuples = #{inspect tuples}, cursor = #{inspect cursor}, acc = #{inspect acc, limit: :infinity}")

    tuple_ended_with_head_of_cursor = tuples |> Enum.find(fn {a, b} -> b == head_of_cursor end)
    case tuple_ended_with_head_of_cursor do
      nil ->
        IO.puts("---- item end with #{head_of_cursor} is not found")
        tuple_starting_with_head_of_cursor = tuples |> Enum.find(fn {a, b} -> a == head_of_cursor end)
        case tuple_starting_with_head_of_cursor do
          nil ->
            IO.puts("---- item begin with #{head_of_cursor} is not found")
            proceed(tuples, rest_of_cursor, acc)
          _ ->
            IO.puts("---- found item begin with #{head_of_cursor} = #{inspect tuple_starting_with_head_of_cursor}")
            {x, y} = tuple_starting_with_head_of_cursor
            acc = [y] ++ acc
            cursor = acc
            proceed(List.delete(tuples, tuple_starting_with_head_of_cursor), cursor, acc)
        end
      _ ->
        IO.puts("---- found item end with #{head_of_cursor} = #{inspect tuple_ended_with_head_of_cursor}")

        replacement_index = Enum.find_index(acc, fn x -> x == head_of_cursor end)
        {x, y} = tuple_ended_with_head_of_cursor
        acc = acc |> List.replace_at(replacement_index, [y, x]) |> List.flatten
        cursor = acc
        proceed(List.delete(tuples, tuple_ended_with_head_of_cursor), cursor, acc)
    end
  end

  def proceed(tuples, [] = cursor, acc) do
    {[first | _], _} = find_start_and_end_points(tuples)
    proceed(tuples, [first], [first] ++ acc)
  end

  def finalize_output(char_list) do
    (char_list
      |> Enum.reverse
      |> Enum.reduce(%{result: "", lookup: MapSet.new()}, fn c, acc ->
       case MapSet.member?(acc.lookup, c) do
         true ->
           acc

         false ->
           Map.put(acc, :result, acc.result <> c) |> Map.put(:lookup, MapSet.put(acc.lookup, c))
       end
     end)).result
  end
end
