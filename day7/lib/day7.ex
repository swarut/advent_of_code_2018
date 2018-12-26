defmodule Day7 do
  def get_input(filename) do
    {:ok, result} = File.read(filename)

    String.split(result, "\n", trim: true)
    |> Enum.map(fn co ->
      [x, y] =
        co |> String.split(["Step ", " must be finished before step ", " can begin."], trim: true)

      {x, y}
    end)
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

    {elements_at_first_position -- elements_at_second_position,
     elements_at_second_position -- elements_at_first_position}
  end

  @doc """
  Process the given data

  ## Example
      iex> Day7.proceed([{"A", "B"}, {"A", "C"}, {"B", "D"}, {"C", "D"}])
      "ABCD"
  """
  def proceed(data) do
    # figure out the fisrt element
    c = first_element(data)
    proceed(data, c, "")
  end
  def proceed([], cursor, acc) do

  end

  @doc """
  Finalize the output

  ## Example
      iex> Day7.finalize_output("EFEDEBAC")
      "CABDFE"
  """
  def finalize_output(str) do
    (str
     |> String.graphemes()
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
