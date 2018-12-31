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
    IO.puts("INPUT = #{inspect tuples}")
    {first, _} = find_start_and_end_points(tuples)
    proceed(%{incoming_lookup: incoming_lookup(tuples), outgoing_lookup: outgoing_lookup(tuples), choices: first}, [])
  end

  def proceed(carry = %{incoming_lookup: incoming_lookup, outgoing_lookup: outgoing_lookup, choices: []}, acc) do
    IO.puts "0:::::::"
    IO.puts "       #{ y("Carry")}"
    # IO.puts "       #{ y("incoming lookup:")} #{inspect incoming_lookup}"
    # IO.puts "       #{ y("outgoing lookup:")} #{inspect outgoing_lookup}"
    IO.puts "       #{ y("acc:")} #{inspect acc}"
    IO.puts "============================== \n"
    acc |> Enum.reverse |> Enum.join("")
  end

  def proceed(carry = %{incoming_lookup: incoming_lookup, outgoing_lookup: outgoing_lookup, choices: choices}, acc) do
    IO.puts "2:::::::"
    # IO.puts "       #{ g("incoming lookup:")} #{inspect incoming_lookup}"
    # IO.puts "       #{ g("outgoing lookup:")} #{inspect outgoing_lookup}"
    IO.puts "       #{ g("choices:")} #{inspect choices}"
    IO.puts "       #{ g("acc:")} #{inspect acc}"
    [next_move | rest_of_choices] = choices

    incoming_links_to_next_move = incoming_lookup[next_move] || []
    IO.puts "       next move: #{inspect next_move}"
    IO.puts "       incoming_links #{next_move}: #{inspect incoming_links_to_next_move}"
    all_incoming_links_to_next_move_proceeded = Enum.all?(incoming_links_to_next_move, fn x -> Enum.member?(acc, x) end)
    case all_incoming_links_to_next_move_proceeded do
      true ->
        IO.puts "                     "
        IO.puts "       can proceed next move"
        outgoings = outgoing_lookup[next_move] || []
        unprocessed_outgoings = outgoings |> Enum.filter(fn x -> !Enum.member?(acc, x) end)
        choices = (unprocessed_outgoings ++ rest_of_choices) |> Enum.uniq |> Enum.sort
        acc = [next_move] ++ acc
        carry = carry
        |> Map.put(:outgoing_lookup, outgoing_lookup |> Map.delete(next_move))
        |> Map.put(:choices, choices)

        # IO.puts "       #{ g("incoming lookup:")} #{inspect incoming_lookup}"
        # IO.puts "       #{ g("outgoing lookup:")} #{inspect outgoing_lookup}"
        IO.puts "       #{ g("choices:")} #{inspect choices}"
        IO.puts "       #{ g("acc:")} #{inspect acc}"
        IO.puts "============================== \n"
        proceed(carry, acc)
      false ->
        IO.puts "                     "
        IO.puts "       #{r("can not")} proceed next move"
        # [next_move | _] = rest_of_choices     # -> wrong assumption, the first item of rest may not give the proceedable node.
        next_move = find_next_move(rest_of_choices, incoming_lookup, outgoing_lookup, acc)
        IO.puts "       #{ g("new next move:")} #{inspect next_move}"   #
        outgoings = outgoing_lookup[next_move] || []
        unprocessed_outgoings = outgoings |> Enum.filter(fn x -> !Enum.member?(acc, x) end)
        choices = (unprocessed_outgoings ++ (rest_of_choices |> List.delete(next_move))) |> Enum.uniq |> Enum.sort
        acc = [next_move] ++ acc
        carry = carry
        |> Map.put(:outgoing_lookup, outgoing_lookup |> Map.delete(next_move))
        |> Map.put(:choices, choices)
        # IO.puts "       #{ y("incoming lookup:")} #{inspect incoming_lookup}"
        # IO.puts "       #{ y("outgoing lookup:")} #{inspect outgoing_lookup}"
        IO.puts "       #{ y("choices:")} #{inspect choices}"
        IO.puts "       #{ y("acc:")} #{inspect acc}"
        IO.puts "============================== \n"
        proceed(carry, acc)
    end
  end

  def find_next_move(choices, incoming_lookup, outgoing_lookup, processed) do
    choices |> Enum.reduce_while(nil, fn c, acc ->
      incoming_links_to_next_move = incoming_lookup[c] || []
        all_incoming_links_to_next_move_proceeded = Enum.all?(incoming_links_to_next_move, fn x -> Enum.member?(processed, x) end)
        case all_incoming_links_to_next_move_proceeded do
          true -> {:halt, c}
          false -> {:cont, c}
        end
    end)
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
    |> Enum.reduce(%{}, fn {k, v}, acc -> acc |> Map.put(k, Enum.sort(v)) end)
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
    |> Enum.reduce(%{}, fn {k, v}, acc -> acc |> Map.put(k, Enum.sort(v)) end)
  end

  def y(t) do
    IO.ANSI.format([:yellow, :bright, t], true)
  end

  def g(t) do
    IO.ANSI.format([:green, :bright, t], true)
  end

  def m(t) do
    IO.ANSI.format([:magenta, :bright, t], true)
  end

  def r(t) do
    IO.ANSI.format([:red, :bright, t], true)
  end
end
