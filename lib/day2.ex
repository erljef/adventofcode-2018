defmodule Day2 do

  def checksum(list) do
    Enum.reduce(list, {0, 0}, fn x, {count_2, count_3} -> add({count_2, count_3}, has_duplicates?(x)) end)
    |> multiply
  end

  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}
  def multiply({x, y}), do: x * y


  def has_duplicates?(string) do
    duplicates = String.graphemes(string)
    |> Enum.group_by(&(&1))
    |> Map.values

    {has_duplicates?(duplicates, 2), has_duplicates?(duplicates, 3)}
  end

  def has_duplicates?(list, length) do
    duplicates = list |> Enum.filter(&(length(&1) == length))
    if length(duplicates) > 0 do 1 else 0 end
  end

  def common(list) do
    [head | rest] = list

    Enum.map(rest, &String.myers_difference(&1, head))
    |> Enum.find(&single_deletion?/1)
    |> case do
      nil -> common(rest)
      x -> x |> Keyword.get_values(:eq) |> List.to_string
    end
  end

  def single_deletion?(diff) do
    Keyword.get_values(diff, :del)
    |> List.to_string
    |> (&(String.length(&1) === 1)).()
  end

  def from_file(path) do
    Helper.read_file(path)
    |> Enum.to_list
    |> List.flatten
  end

  def solution do
    IO.puts("#{from_file("day2_input.txt") |> checksum}")
    IO.puts("#{from_file("day2_input.txt") |> common}")
  end
end
