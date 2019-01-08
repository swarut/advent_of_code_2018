defmodule Day7 do
  def get_input(filename) do
    {:ok, result} = File.read(filename)

    String.split(result, "\n", trim: true)
    |> Enum.map(fn co ->
      [x, y] =
        co |> String.split(["Step ", " must be finished before step ", " can begin."], trim: true)

      {x, y}
    end)
    |> Enum.sort()
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

    {(elements_at_first_position -- elements_at_second_position) |> Enum.reverse(),
     (elements_at_second_position -- elements_at_first_position) |> Enum.reverse()}
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
    {first, _} = find_start_and_end_points(tuples)

    proceed(
      %{
        incoming_lookup: incoming_lookup(tuples),
        outgoing_lookup: outgoing_lookup(tuples),
        choices: first
      },
      []
    )
  end

  def proceed(%{choices: []}, acc) do
    acc |> Enum.reverse() |> Enum.join("")
  end

  def proceed(
        carry = %{
          incoming_lookup: incoming_lookup,
          outgoing_lookup: outgoing_lookup,
          choices: choices
        },
        acc
      ) do
    next_move = find_next_move(choices, incoming_lookup, acc)
    outgoings = outgoing_lookup[next_move] || []
    unprocessed_outgoings = outgoings |> Enum.filter(fn x -> !Enum.member?(acc, x) end)

    choices =
      (unprocessed_outgoings ++ (choices |> List.delete(next_move))) |> Enum.uniq() |> Enum.sort()

    acc = [next_move] ++ acc

    carry =
      carry
      |> Map.put(:outgoing_lookup, outgoing_lookup |> Map.delete(next_move))
      |> Map.put(:choices, choices)

    proceed(carry, acc)
  end

  def find_next_move(choices, incoming_lookup, processed) do
    choices
    |> Enum.reduce_while(nil, fn c, _ ->
      incoming_links_to_next_move = incoming_lookup[c] || []

      all_incoming_links_to_next_move_proceeded =
        Enum.all?(incoming_links_to_next_move, fn x -> Enum.member?(processed, x) end)

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

  @doc """
  Return the map of duration for the given steps

  ## Example
      iex> Day7.steps_to_durations("ABC")
      %{"A" => 61, "B" => 62, "C" => 63}
  """
  def steps_to_durations(steps) do
    step_durations = (for n <- ?A..?Z, do: << n :: utf8 >>) |> Enum.with_index(61) |> Enum.into(%{})

    steps
    |> String.graphemes
    |> Enum.reduce(%{}, fn s, acc ->
      Map.put(acc, s, step_durations[s])
    end)
  end

  @doc """
  Calculate the duration for completing the task with specific amount of worker

  ## Example
      iex> Day7.duration("AB", 1)
      123
      iex> Day7.duration("AB", 2)
      62
  """
  def duration(steps, worker, incoming_lookup) do
    duration(steps, steps_to_durations(steps), worker, incoming_lookup, [], 0)
  end

  # def duration(_, _step_durations, _worker, _incoming_lookup, _processing, 20), do: 20
  def duration("", _step_durations, _worker, _incoming_lookup, _processing, acc), do: acc

  def duration(steps, step_durations, worker, incoming_lookup, processing, second_count) do

    possible_steps = get_possible_steps(steps, incoming_lookup, worker, processing) |> Enum.take(worker)
    processing = possible_steps
    IO.puts("STEPS: #{steps}")
    IO.puts("PROCESS at second: #{second_count}")
    IO.puts("\tPossible step: #{inspect possible_steps}")
    IO.puts("\tStep duration: #{inspect step_durations}")

    # Progress
    step_durations = step_durations |> Enum.reduce(%{}, fn {k, v}, acc ->
      case Enum.member?(possible_steps, k) do
        true ->
          acc |> Map.put(k, v - 1)
        false ->
          acc |> Map.put(k, v)
      end
    end)

    # Get list of steps to update for incoming links
    finished_steps = step_durations |> Enum.reduce([], fn {k, v}, acc ->
      case v do
        0 -> [k] ++ acc
        _ -> acc
      end
    end)

    processing = processing -- finished_steps

    # Get rid of steps that are finished
    step_durations = step_durations |> Enum.reduce(%{}, fn {k, v}, acc ->
      case v do
        0 -> acc
        _ -> acc |> Map.put(k, v)
      end
    end)

    incoming_lookup = incoming_lookup |> Enum.reduce(%{}, fn {k, v}, acc ->
      remaining_deps = v -- finished_steps
      case remaining_deps do
        [] -> acc
        _ -> Map.put(acc, k, remaining_deps)
      end
    end)
    IO.puts("---- FINISHED STEPS = #{inspect finished_steps}")
    IO.puts("---- updated_incoming_lookup = #{inspect incoming_lookup}")
    IO.puts("==================\n")

    steps = case finished_steps do
      [] -> steps
      _ -> steps |> String.replace(finished_steps, "")
    end
    duration(steps, step_durations, worker, incoming_lookup, processing, second_count + 1)
  end

  @doc """
  Get possible steps where incoming link count eqauls to zero

  ## Example
      iex> Day7.get_possible_steps("AB", %{"B" => ["A"]})
      ["A"]
      iex> Day7.get_possible_steps("CAB", %{"B" => ["A"]})
      ["A", "C"]
  """
  def get_possible_steps(steps, incoming_lookup, worker, processing) do
    steps_with_incoming_links = incoming_lookup |> Map.keys
    steps_with_zero_incoming_links = steps
    |> String.graphemes |> Enum.filter(fn c -> !Enum.member?(steps_with_incoming_links, c) && !Enum.member?(processing, c) end) |> Enum.sort

    to_take = worker - length(processing)
    processing ++ Enum.take(steps_with_zero_incoming_links, to_take)
  end


end
