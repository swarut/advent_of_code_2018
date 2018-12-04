import Claim

defmodule Day3 do

  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true) |> Enum.map(fn line -> get_spec(line) |> map_claim end)
  end

  def get_spec(line) when is_binary(line) do
    String.split(line, ["#", " @ ", ",",": ", "x"], trim:  true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def map_claim(spec) when is_list(spec) do
    [id, left, top, wide, tall] = spec
    %Claim{left: left, top: top, wide: wide, tall: tall, start_x: left, end_x: left + wide, start_y: top, end_y: top + tall, id: id}
  end

  def solve do
    res = get_input("input.txt")
    |> Enum.reduce(%{}, fn claim, acc ->
      Enum.reduce((claim.left + 1)..(claim.left + claim.wide), acc, fn(x, x_acc) ->
        Enum.reduce((claim.top + 1)..(claim.top + claim.tall), x_acc, fn(y, y_acc) ->
          case acc[{x, y}] do
            nil -> Map.put(y_acc, {x, y}, [claim.id])
            list -> Map.put(y_acc, {x, y}, [claim.id | list])
          end
        end)
      end)
    end)
    |> Map.to_list
    |> Enum.reduce(0, fn {key, value}, acc ->
      case length(value) do
        1 -> acc
        _ -> acc + 1
      end
    end)
    |> inspect
  end

end
