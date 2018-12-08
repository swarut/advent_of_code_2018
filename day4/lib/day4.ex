defmodule Day4 do
  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true) |> Enum.sort
  end

  def parse_log(log, acc) do
    [year, month, day, h, m] =
      String.slice(log, 0, 18) |> String.split(["[", "-", "-", " ", ":", "]"], trim: true)

    action_chunk = String.slice(log, 19, String.length(log))
    c = String.split(action_chunk, " ")

    [action, id] =
      case c do
        ["Guard", "#" <> id, _, _] -> [:on, id]
        ["falls", _] -> [:off, acc[:current_guard]]
        ["wakes", _] -> [:on, acc[:current_guard]]
      end
    
    %{
        action: action,
        id: id,
        date: {"#{year}-#{month}-#{day}"},
        year: year,
        month: month,
        day: day,
        hour: String.to_integer(h),
        minute: String.to_integer(m)
      }
  end

  def time_records do
    get_input("input2.txt")
    |> Enum.reduce(%{current_guard: nil}, fn log, acc ->
      record = parse_log(log, acc)

      acc =
        Map.put(acc, :current_guard, record.id)
        |> Map.update(record.id, [record], fn current_value ->
          current_value ++ [record]
        end)
        |> Map.update(record.date, %{record.id => [{record.minute, record.action}]}, fn current_date_map ->
          Map.update(current_date_map, record.id, [{record.minute, record.action}], fn current_date_map_id_list ->
            current_date_map_id_list ++ [{record.minute, record.action}]
          end)
        end)
    end)
    |> Map.delete(:current_guard)
  end

  def solve do
    time_records
  end
end
