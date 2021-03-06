defmodule Solution do
  def get_input do
    {:ok, result} = File.read("input.txt")
    String.split(String.trim(result), "\n")
  end

  def part1_solve do
    list = get_input()

    char_counters =
      Enum.map(list, fn item ->
        chars = String.graphemes(item)

        Enum.reduce(chars, %{2 => 0, 3 => 0}, fn x, acc ->
          case acc[x] do
            nil ->
              Map.put(acc, x, 1)

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

    %{2 => two_count, 3 => three_count} =
      Enum.reduce(char_counters, %{2 => 0, 3 => 0}, fn x, acc ->
        case [x[2], x[3]] do
          [0, 0] -> acc
          [_, 0] -> Map.put(acc, 3, acc[3] + 1)
          [0, _] -> Map.put(acc, 2, acc[2] + 1)
          [_, _] -> Map.put(acc, 2, acc[2] + 1) |> Map.put(3, acc[3] + 1)
        end
      end)

    IO.puts(two_count * three_count)
  end

  def part2_solve do
    list = get_input()
    [first_row | _] = Enum.take(list, 1)
    string_length = String.length(first_row)

    range = 0..(string_length - 1)
    common = Enum.reduce_while(range, nil, fn index, acc ->
      modified_strings = remove_char_at(list, index) |> Enum.sort()

      loop_result =
        Enum.reduce_while(modified_strings, %{previous_seen: nil, matched_common: nil}, fn a_string, inner_acc ->
          cond do
            inner_acc[:previous_seen] == a_string -> {:halt, Map.put(inner_acc, :matched_common, a_string)}
            true -> {:cont, Map.put(inner_acc, :previous_seen, a_string)}
          end
        end)

      case loop_result[:matched_common] do
        nil -> {:cont, acc}
        common -> {:halt, common}
      end
    end)
    IO.puts "Common: #{common}"
  end

  def remove_char_at(list, index) do
    Enum.map(list, fn x ->
      length = String.length(x)

      head =
        case index do
          0 -> ""
          ^length -> String.slice(x, 0, length - 1)
          _ -> String.slice(x, 0, index)
        end

      tail =
        case index do
          0 -> String.slice(x, 1, length)
          ^length -> ""
          _ -> String.slice(x, index + 1, length)
        end

      head <> tail
    end)
  end
end

Solution.part1_solve()
Solution.part2_solve()
