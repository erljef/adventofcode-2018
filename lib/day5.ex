defmodule Day5 do
  def from_file(path) do
    File.read!(path)
    |> String.graphemes
    |> Enum.filter(&(&1 != "\n"))
  end

  def react(list) do
    List.foldr(list, [], &react/2)
  end

  def react(x, []), do: [x]
  def react(x, [head | tail]) do
    if x != head && String.downcase(x) == String.downcase(head) do
      tail
    else
      [x, head | tail]
    end
  end

  def shortest_polymer(list) do
    ?a..?z |> Enum.to_list |> List.to_string |> String.graphemes
    |> Enum.map(fn letter -> list |> Enum.filter(&(&1 != letter && &1 != String.upcase(letter))) |> react end)
    |> Enum.reduce(fn x, acc -> if length(x) < length(acc) do x else acc end end)
  end

  def solution do
    IO.puts("#{from_file("day5_input.txt") |> react |> Enum.count}")
    IO.puts("#{from_file("day5_input.txt") |> shortest_polymer |> Enum.count}")
  end
end
