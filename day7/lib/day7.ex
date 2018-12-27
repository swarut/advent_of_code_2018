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
    proceed(%{incoming_lookup: incoming_lookup(tuples), outgoing_lookup: outgoing_lookup(tuples), first: first}, [first])
  end

  def proceed(carry = %{incoming_lookup: incoming_lookup, outgoing_lookup: outgoing_lookup, first: first}, acc) do
    choices = outgoing_lookup[first] |> Enum.sort
    acc = [first] ++ acc

    carry = carry
    |> Map.put(outgoing_lookup: outgoing_lookup |> Map.delete(first))
    |> Map.put(choices: choices)

    proceed(carry, acc)
  end

  def proceed(%{incoming_lookup: incoming_lookup, outgoing_lookup: outgoing_lookup, choices: choices}, acc) do
    [c | _] = choices

  end

  @doc """
  Generate incoming lookup

  ## Example
      iex> Day7.incoming_lookup([{"A", "B"}, {"B", "C"}])
      %{
        "B" => ["A"],
        "C" => ["B"]
      }
  """
  def incoming_lookup(tuples) do
    tuples
    |> Enum.reduce(%{}, fn {a, b}, acc ->
      Map.update(acc, b, [a], fn current_value ->
        [a] ++ current_value
      end)
    end)
  end

  @doc """
  Generate outgoing lookup

  ## EXample
      iex> Day7.outgoing_lookup([{"A", "B"}, {"B", "C"}])
      %{
        "A" => ["B"],
        "B" => ["C"]
      }
  """
  def outgoing_lookup(tuples) do
    tuples
    |> Enum.reduce(%{}, fn {a, b}, acc ->
      Map.update(acc, a, [b], fn current_value ->
        [b] ++ current_value
      end)
    end)
  end
end
