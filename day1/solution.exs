defmodule Solver do

  def part1_solve do
    get_input()
    |> Enum.reduce(0, fn (x, acc) -> acc + x end)
  end

  def get_input do
    {:ok, result} = File.read("input.txt")
    String.split(result, "\n", trim: true) 
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def part2_solve(acc = %{match: matched, current_freq: current_freq, seen: seen, time: time}, list) do
    IO.puts "TIME: #{inspect(time)}"
    IO.puts "LIST : #{inspect(list)}"
    IO.puts "MATCH : #{inspect(matched)}"
    IO.puts "ACC : #{inspect(acc)}"
    IO.puts "SEEN: #{inspect(seen)}"
    IO.puts "---------------------------"

    case matched do
      nil -> 
        [h|t] = list
        new_freq = current_freq + h
        may_be_found = case seen[new_freq] do
          nil -> nil
          _ -> new_freq
        end
        seen = Map.put(seen, new_freq, new_freq)

        acc = Map.put(acc, :current_freq, new_freq)
        acc = Map.put(acc, :match, may_be_found)
        acc = Map.put(acc, :seen, seen)
        acc = Map.put(acc, :time, time + 1 )
        part2_solve(acc, t ++ [h])
      _ -> matched
    end
  end

end

IO.puts Solver.part1_solve()
IO.puts Solver.part2_solve(%{match: nil, current_freq: 0, seen: %{}, time: 0}, Solver.get_input())
