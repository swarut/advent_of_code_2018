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

    next = tuples |> Enum.find(fn {a, b} -> a == head_of_cursor end)
    case next do
      nil ->
        IO.puts("---- item begin with #{head_of_cursor} is not found")
        proceed(tuples, rest_of_cursor, acc)
      _ ->
        IO.puts("---- found #{inspect next}")
        {x, y} = next
        acc = [y] ++ acc
        cursor = acc
        proceed(List.delete(tuples, next), cursor, acc)
    end
  end

  def proceed(tuples, [] = cursor, acc) do
    {[first | _], _} = find_start_and_end_points(tuples)
    proceed(tuples, [first], [first] ++ acc)
  end

  @doc """
  Finalize the output

  ## Example
      iex> Day7.finalize_output(["E", "F", "E", "D", "E", "B", "A", "C"])
      "CABDFE"
  """
  def finalize_output(char_list) do
    (char_list
     |> Enum.reduce(%{result: "", lookup: MapSet.new()}, fn c, acc ->
       case MapSet.member?(acc.lookup, c) do
         true ->
           acc

         false ->
           Map.put(acc, :result, c <> acc.result) |> Map.put(:lookup, MapSet.put(acc.lookup, c))
       end
     end)).result
  end
end


# {"C", "A"}	o
# {"C", "F"}	o
# {"A", "B"}	o
# {"A", "D"}	o
# {"B", "E"}	o
# {"D", "E"}	o
# {"F", "E"}



# C A {"C", "A"}      		cursor A

# C A B {"A", "B"}    		cursor B

# C A B E {"B", "E"}		cursor E

# no E

# move cursor bck			cursor B

# no B

# move cusor back			cussor A

# C A B E D {"A", "D"}		cursor D

# C A B E D E	{"D", "E"}	cursor E

# no e

# move cursor back			cursor D

# no D

# move curso back			cursor E

# no E

# move cursor back			cursor B

# no B

# move cursor back    		cursor A

# no A

# move cursor back    		cursor C

# C A B E D E F	{"C", "F"}

# C A B E D E F E {"F", "E"}

# no input
