defmodule Solver do

  def solve do
    {:ok, result} = File.read("input.txt")
    String.split(String.trim(result), "\n") 
    |> Enum.reduce(0, fn (x, acc) -> acc + String.to_integer(x) end)
  end

  def get_input do
    {:ok, result} = File.read("input2.txt")
    String.split(String.trim(result), "\n") 
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def part2_solve(acc = %{match: matched, current_freq: current_freq, history: history, time: time}, list) do
    IO.puts "TIME: #{inspect(time)}"
    IO.puts "LIST : #{inspect(list)}"
    IO.puts "MATCH : #{inspect(matched)}"
    IO.puts "ACC : #{inspect(acc)}"
    IO.puts "HISTORY: #{inspect(history)}"
    IO.puts "---------------------------"

    case matched do
      nil -> 
        [h|t] = list
        new_freq = current_freq + h
        may_be_found = case history[new_freq] do
          nil -> nil
          _ -> new_freq
        end
        history = Map.put(history, new_freq, new_freq)

        acc = Map.put(acc, :current_freq, new_freq)
        acc = Map.put(acc, :match, may_be_found)
        acc = Map.put(acc, :history, history)
        acc = Map.put(acc, :time, time + 1 )
        part2_solve(acc, t ++ [h])
      _ -> matched
    end
  end

end

# IO.puts Solver.solve()
IO.puts Solver.part2_solve(%{match: nil, current_freq: 0, history: %{}, time: 0}, Solver.get_input())
