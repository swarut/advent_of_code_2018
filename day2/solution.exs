defmodule Solution do
  def get_input do
    {:ok, result} = File.read("input.txt")
    String.split(String.trim(result), "\n")
  end

  def part1_solve do
    list = get_input()
    char_counters = Enum.map(list, fn(item) -> 
      chars = String.graphemes(item)
      Enum.reduce(chars, %{2 => 0, 3 => 0}, fn (x, acc) ->
        case acc[x] do
          nil -> Map.put(acc, x, 1)
          count -> 
            new_count = count + 1
            acc = Map.put(acc, x, new_count)
            case new_count do
              2 -> Map.put(acc, 2, acc[2] + 1)
              3 -> Map.put(acc, 3, acc[3] + 1) |> Map.put(2, acc[2] - 1)
              _ -> acc
            end
        end
      end)
    end)
    
    %{ 2 => two_count, 3 => three_count} = Enum.reduce(char_counters, %{2 => 0, 3 => 0}, fn (x, acc) ->
      case [x[2], x[3]] do
        [0, 0] -> acc
        [_, 0] -> Map.put(acc, 3, acc[3] + 1)
        [0, _] -> Map.put(acc, 2, acc[2] + 1)
        [_, _] -> Map.put(acc, 2, acc[2] + 1) |> Map.put(3, acc[3] + 1)
      end
    end)

    IO.puts(two_count * three_count)
  end
end

Solution.part1_solve()
