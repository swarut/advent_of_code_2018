import Claim

defmodule Day3 do

  def get_input(filename) do
    {:ok, result} = File.read(filename)
    String.split(result, "\n", trim: true) |> Enum.map(fn line -> get_spec(line) |> map_claim end)
  end

  def get_spec(line) when is_binary(line) do
    String.split(line, [" ", "@"], trim:  true)
    |> Enum.reduce([], fn x, acc ->
      case String.starts_with?(x, "#") do
        true -> acc
        _ -> acc ++ [x]
      end
    end)
  end

  def map_claim(spec) when is_list(spec) do
    [left_top, wide_tall] = spec
    [left, top] = left_top |> String.split([",", ":"], trim: true) |> Enum.map(fn x -> String.to_integer(x) end)
    [wide, tall] = wide_tall |> String.split("x") |> Enum.map(fn x -> String.to_integer(x) end)
    %Claim{left: left, top: top, wide: wide, tall: tall, start_x: left, end_x: left + wide, start_y: top, end_y: top + tall}
  end

  def compute_overlapped(claim1, claim2) when is_map(claim1) and is_map(claim2) do
    %Claim{start_x: c1_start_x, end_x: c1_end_x, start_y: c1_start_y, end_y: c1_end_y, wide: c1_wide, tall: c1_tall} = claim1
    %Claim{start_x: c2_start_x, end_x: c2_end_x, start_y: c2_start_y, end_y: c2_end_y, wide: c2_wide, tall: c2_tall} = claim2

  end

  def solve do
    10
    # claims = get_input("input.txt")

  end

end
