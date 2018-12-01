defmodule Day1 do

  def frequency(list) do
    Enum.sum(list)
  end

  def first_duplicate(list) do
    list
    |> Stream.cycle
    |> Enum.reduce_while({0, MapSet.new([0])}, fn i, {current, seen} ->
      f = current + i
      if MapSet.member?(seen, f) do
        {:halt, f}
      else
        {:cont, {f, MapSet.put(seen, f)}}
      end
    end)
  end

  def from_file(path) do
    Helper.read_file(path)
    |> Enum.to_list
    |> List.flatten
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&(elem(&1, 0)))
  end

  def solution do
    IO.puts("#{from_file("day1_input.txt") |> frequency}")
    IO.puts("#{from_file("day1_input.txt") |> first_duplicate}")
  end
end
