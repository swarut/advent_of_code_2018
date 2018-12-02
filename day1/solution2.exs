defmodule Solver do
  
  def part1_solve(list) do
    Enum.reduce(list, 0, fn (x, acc) -> acc + x end)
  end

  def get_input do
    {:ok, result} = File.read("input2.txt")
    String.split(String.trim(result), "\n") 
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def part2_solve(list) do
    IO.puts("Input list = #{inspect(list)}")
    loop_sum = part1_solve(list)
    possible_base = Enum.reduce(list, [0], fn (x, acc) ->
      [h|_] = acc
      [x + h] ++ acc
    end)
    [_|possible_base] = possible_base

    group = Enum.reduce(possible_base, %{}, fn(x, acc) ->
      IO.puts("process - #{x}")
      remainder = rem(abs(x), loop_sum)
      case acc[remainder] do
        nil ->
          Map.put(acc, remainder, [x])
        value ->
          Map.put(acc, remainder, acc[remainder] ++ [x])
      end
    end)
    
    IO.puts("GROUP:: #{inspect(group)}")
    IO.puts("POS BASE:: #{inspect possible_base}")
  end
end

# IO.puts Solver.part1_solve(Solver.get_input())
IO.puts Solver.part2_solve(Solver.get_input())
