defmodule Day4 do

  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true)
  end

  def time_records do
    get_input("input2.txt")
    |> Enum.reduce(%{current_guard: nil}, fn record, acc ->
      [year, month, day, h, m] = String.slice(record, 0, 18) |> String.split(["[","-","-"," ",":","]"], trim: true)
      action_chunk = String.slice(record, 19, String.length(record))
      c = String.split(action_chunk, " ")
      IO.puts "C: #{inspect c}"
      [action, id] = case c do
        ["Guard", "#" <> id, _, _] -> ["ch-in", id]
        ["falls", _] -> ["falls", acc[:current_guard]]
        ["wakes", _] -> ["wakes", acc[:current_guard]]
      end
      IO.puts "ACTION: #{action}, ID: #{id}"

      record = %{action: action, timestamp: {year, month, day, h, m}}
      acc = Map.put(acc, :current_guard, id)
      |> Map.update(id, [record], fn current_value ->
        current_value ++ [record]
      end)
    end)
    # |> inspect
  end

  def solve do
    # %{
    #   "10" => {
    #     "1519-10-03" => [".", ".", ".", "#", "#", "#"..............],
    #     "1519-10-04" => [".", ".", ".", "#", "#", "#"..............]
    #     "1519-10-05" => [".", ".", ".", "#", "#", "#"..............]
    #   }
    # }
    # %{
    #   "10" => {
    #     "1519-10-03" => sleep_hour,
    #     "1519-10-04" => sleep_hour,
    #     "1519-10-05" => sleep_hour
    #   }
    # }
    # %{
    #   "10" => best_minute,
    #   "11" => best_minute
    # }

    time_rcords

  end
end
