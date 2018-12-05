defmodule Day4 do

  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true) |> Enum.map(fn line -> get_spec(line) |> map_claim end)
  end
end
