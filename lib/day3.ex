defmodule Day3 do
  def overlap(claims) do
    claims
    |> Enum.flat_map(&claim_to_points/1)
    |> Enum.group_by(fn {_, x, y} -> {x, y} end)
    |> Map.values
    |> Enum.filter(fn l -> length(l) > 1 end)
    |> Enum.count
  end

  def claims(list) do
    list
    |> Enum.map(&parse_claim/1)
  end

  def parse_claim(row) do
    [id, x1, y1, w, h] = Regex.run(~r{#(\d+) @ (\d+),(\d+): (\d+)x(\d+)}, row, capture: :all_but_first)
                     |> Enum.map(&String.to_integer/1)

    {id, {x1 + 1, y1 + 1}, {x1 + w, y1 + h}}
  end

  def claim_to_points({id, {x1, y1}, {x2, y2}}) do
    for x <- x1..x2, y <- y1..y2 do
      {id, x, y}
    end
  end

  def from_file(path) do
    File.stream!(path)
  end

  def no_overlap(claims) do
    all_ids = claims |> Enum.map(fn {id, _, _} -> id end) |> Enum.uniq

    overlapping_ids = claims
    |> Enum.flat_map(&claim_to_points/1)
    |> Enum.group_by(fn {_, x, y} -> {x, y} end)
    |> Map.values
    |> Enum.filter(fn l -> length(l) > 1 end)
    |> List.flatten
    |> Enum.map(fn {id, _, _} -> id end)
    |> Enum.uniq

    MapSet.difference(MapSet.new(all_ids), MapSet.new(overlapping_ids)) |> MapSet.to_list |> Enum.at(0)
  end

  def solution do
    IO.puts("#{from_file("day3_input.txt") |> claims |> overlap}")
    IO.puts("#{from_file("day3_input.txt") |> claims |> no_overlap}")
  end

end
