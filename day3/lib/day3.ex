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
    %Claim{left: left, top: top, wide: wide, tall: tall}
  end

end
