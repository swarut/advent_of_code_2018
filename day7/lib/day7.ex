defmodule Day7 do

  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true)
    |> Enum.map(fn co ->
      [x, y] = co |> String.split(["Step ", " must be finished before step ", " can begin."], trim: true)
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
    {elements_at_first_position, elements_at_second_position} = tuples
    |> Enum.reduce({[], []}, fn({a, b}, {a_col, b_col}) ->
      {([a] ++ a_col) |> Enum.uniq, ([b] ++ b_col) |> Enum.uniq}
    end)
    {elements_at_first_position -- elements_at_second_position, elements_at_second_position -- elements_at_first_position}
  end

end
