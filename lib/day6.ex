defmodule Day6 do
  def from_file(path) do
    File.stream!(path)
    |> Enum.map(
         &(
           String.split(&1, ",")
           |> Enum.map(
                fn x ->
                  x
                  |> String.trim
                  |> String.to_integer end
              )
           |> List.to_tuple)
       )
  end

  def largest_area(points) do
    areas(points)
    |> Enum.map(fn {_, area} -> length(area) end)
    |> Enum.max
  end

  def areas(points) do
    bounds = bounds(points)
    bounded_coordinates(bounds)
    |> Enum.reduce(
         %{},
         fn coordinate, map ->
           map
           |> Map.put(
                coordinate,
                nearest_neighbour(points, coordinate)
              )
         end
       )
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.group_by(fn {_, v} -> v end)
    |> Enum.map(fn {k, v} -> {k, Enum.map(v, fn {p, _} -> p end)} end)
    |> Enum.filter(fn {_, v} -> finite?(v, bounds) end)
  end

  def finite?(points, bounds) do
    !infinite?(points, bounds)
  end

  def infinite?(points, {min_x, max_x, min_y, max_y}) do
    points |> Enum.find(fn {x, y} -> x <= min_x || x >= max_x || y <= min_y || y >= max_y end)
  end

  def bounded_coordinates({min_x, max_x, min_y, max_y}) do
    for y <- min_y..max_y, x <- min_x..max_x, do: {x, y}
  end

  def nearest_neighbour(points, point) do
    [{{x, y}, d1}, {_, d2}] = points
    |> Enum.map(fn p -> {p, distance(p, point)} end)
    |> Enum.sort(fn {_, d1}, {_, d2} -> d1 <= d2 end)
    |> Enum.take(2)

    if d1 == d2 do
      nil
    else
      {x, y}
    end
  end

  def distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def bounds(points) do
    min_x = points |> Enum.map(&elem(&1, 0)) |> Enum.min
    max_x = points |> Enum.map(&elem(&1, 0)) |> Enum.max
    min_y = points |> Enum.map(&elem(&1, 1)) |> Enum.min
    max_y = points |> Enum.map(&elem(&1, 1)) |> Enum.max

    {min_x, max_x, min_y, max_y}
  end

  def largest_close(points, max_total_distance) do
    bounded_coordinates(bounds(points))
    |> Enum.reduce(
         %{},
         fn coordinate, map ->
           map
           |> Map.put(
                coordinate,
                total_distance(points, coordinate)
              )
         end
       )
    |> Enum.filter(fn {_, v} -> v < max_total_distance end)
    |> length
  end

  def total_distance(points, coordinate) do
    points
    |> Enum.map(fn point -> distance(point, coordinate) end)
    |> Enum.sum
  end

  def solution do
    IO.puts("#{from_file("day6_input.txt") |> largest_area}")
    IO.puts("#{from_file("day6_input.txt") |> largest_close(10000)}")
  end
end
