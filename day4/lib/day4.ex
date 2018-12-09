defmodule Day4 do
  use Bitwise
  
  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true) 
    |> Enum.sort
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
        date: "#{year}-#{month}-#{day}",
        year: year,
        month: month,
        day: day,
        hour: String.to_integer(h),
        minute: String.to_integer(m)
      }
  end

  def time_records do
    get_input("input.txt")
    |> Enum.reduce(%{current_guard: nil}, fn log, acc ->
      record = parse_log(log, acc)
      acc =
        Map.put(acc, :current_guard, record.id)
        |> Map.update(record.date, %{record.id => [{record.minute, record.action}]}, fn current_date_map ->
          Map.update(current_date_map, record.id, [{record.minute, record.action}], fn current_date_map_id_list ->
            current_date_map_id_list ++ [{record.minute, record.action}]
          end)
        end)
    end)
    |> Map.delete(:current_guard)
  end

  def id_minutes do
    ts = time_records
    |> Enum.map(fn {date, id_records} ->
      computed_sleep_times = Enum.map(id_records, fn {id, records} -> 
        range_and_total_sleep_time = range_and_total_sleep_time_from_time_log(records)
        |> Enum.map(fn item -> Enum.to_list(item) end) |> List.flatten |> Enum.sort
        {id, range_and_total_sleep_time}
      end)
      {date, computed_sleep_times}
    end)

    Enum.map(ts, fn {k, v} -> v end)  # Remove date 
    |> List.flatten
    |> Enum.reduce(%{}, fn {id, minutes}, acc ->
      Map.update(acc, id, [minutes], fn current_value -> [minutes] ++ current_value end)
    end)
  end

  def id_minutes_count(id_minutes) do
    Map.to_list(id_minutes) |> Enum.map( fn {k, v} -> {k, Enum.map(v, fn i -> length(i) end) |> Enum.sum } end)
  end

  def part1_solve do
    id_minutes = id_minutes()

    id_minutes_count = id_minutes_count(id_minutes)
    {max_key, _} = Enum.max_by(id_minutes_count, fn {_k, v} -> v end)

    picked_guard = common_time(id_minutes[max_key])
    {picked_minute, _} = Enum.max_by(picked_guard, fn {_,v } -> v end)
    String.to_integer(max_key) * picked_minute
  end

  def part2_solve do
    id_minutes = id_minutes()
    # rec = Map.keys(id_minutes) |> Enum.map( fn y -> Day4.common_time(id_minutes[y]) end)
    rec = Enum.map(id_minutes, fn {k, v} -> 
      {k, Day4.common_time(v) |> Map.to_list }
    end)

    flatten_distributions = Enum.map(rec, fn {id, minutes_distributions} -> minutes_distributions end) |> List.flatten
    final_distributions = Enum.reduce(flatten_distributions, %{}, fn {minute, count}, acc -> 
      Map.update(acc, minute, count, fn current_minute ->
        current_minute + count
      end)
    end)
    |> Enum.sort(fn {k1, v1}, {k2, v2} ->  v2 < v1 end)
    |> Enum.reverse
    |> Enum.reverse
    rec

    Enum.reduce(rec, %{}, fn {id, minute_distributions}, acc ->
      case minute_distributions do
        [] -> Map.put(acc, id, [])
        _ ->
          IO.puts(inspect minute_distributions, charlists: false)
          max = Enum.max_by(minute_distributions, fn {m, c} -> c end)
          Map.put(acc, id, max)
      end
    end)
  end

  def range_and_total_sleep_time_from_time_log(records) do
    range_and_total_sleep_time_from_time_log(records, acc = [])
  end

  def range_and_total_sleep_time_from_time_log(records = [{time, :on} | rest], [last_minute | rest_acc]) when is_integer(last_minute) do
    range = last_minute..(time - 1)
    new_rest_acc = [range] ++ rest_acc
    range_and_total_sleep_time_from_time_log(rest, new_rest_acc)
  end
  def range_and_total_sleep_time_from_time_log(records = [{time, :on} | rest], acc = [last_minute | rest_acc]) when is_map(last_minute) do
    range_and_total_sleep_time_from_time_log(rest, rest_acc)
  end
  def range_and_total_sleep_time_from_time_log(records = [{time, :on} | rest], acc) do
    range_and_total_sleep_time_from_time_log(rest, acc)
  end

  # This case should not occur.
  # def range_and_total_sleep_time_from_time_log([{time, :off} | rest], [last_minute | rest_acc]) when is_integer(last_minute) do
  # end
  def range_and_total_sleep_time_from_time_log(records = [{time, :off} | rest], acc = []) do
    new_rest_acc = [time]
    range_and_total_sleep_time_from_time_log(rest, new_rest_acc)
  end
  def range_and_total_sleep_time_from_time_log(records = [{time, :off} | rest], acc = [last_minute | rest_acc]) when is_map(last_minute) do
    new_rest_acc = [time] ++ acc
    range_and_total_sleep_time_from_time_log(rest, new_rest_acc)
  end

  def range_and_total_sleep_time_from_time_log(records = [], acc) do acc end

  def common_time(list) do
    # IO.puts inspect(list, charlists: false)
    Enum.reject(list, fn x -> length(x) == 0 end)
    |> Enum.reduce(%{}, fn minutes, acc ->
      Enum.reduce(minutes, acc, fn minute, minute_acc -> 
        Map.update(minute_acc, minute, 1, fn current_value -> 
          current_value + 1
        end)
      end) 
    end)
  end

  # Can't make this perfect
  # def common_time(list) do
  #   Enum.reject(list, fn x -> length(x) == 0 end)
  #   |> Enum.reduce(nil, fn items, acc ->
  #     # processed_item = Enum.map(items, fn item -> 0b1 <<< item end) |> Enum.reduce(0, fn item, acc2 -> bor(item, acc2) end)
  #     processed_item = Enum.reduce(0, fn item, acc2 -> bor(item, acc2) end)
  #     case acc do
  #       nil -> processed_item
  #       current_value -> band(processed_item, current_value)
  #     end
  #   end)
  #   |> :math.log2
  # end

end
