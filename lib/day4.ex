defmodule Day4 do
  def from_file(path) do
    File.stream!(path)
    |> Enum.sort
    |> Enum.map(&parse_row/1)
  end

  def parse_row(row) do
    [date, hour, minute, action] = Regex.run(~r{\[(\d\d\d\d-\d\d-\d\d) (\d\d):(\d\d)\] (.*)}, row, capture: :all_but_first)
    {date, hour, String.to_integer(minute), parse_action(action)}
  end

  def parse_action("wakes up"), do: :awake
  def parse_action("falls asleep"), do: :asleep
  def parse_action("Guard #" <> rest) do
    [id, _, _] = String.split(rest)
    String.to_integer(id)
  end

  def most_asleep(list) do
    accumulated_minutes = Enum.reduce(list, Map.new, fn x, acc -> sum_minutes(x, acc) end)

    {most_asleep_id, _} = Map.to_list(accumulated_minutes)
                  |> Enum.filter(fn {k, _} -> is_number(k) end)
                  |> Enum.reduce(fn {id, minutes}, {a_id, a_minutes} -> if minutes > a_minutes do {id, minutes} else {a_id, a_minutes} end end)

    {most_asleep_minute, _} = Map.to_list(accumulated_minutes) |> Enum.filter(fn {k, _} -> is_tuple(k) end) |> Enum.filter(fn {{id, _}, _} -> id == most_asleep_id end) |> Enum.reduce({0, 0}, fn {{_, minute}, minutes}, {_, a_minutes} = a -> if minutes > a_minutes do {minute, minutes} else a end end)
    {most_asleep_id, most_asleep_minute}
  end

  def sum_minutes({_, _, _, id}, acc) when is_number(id), do: Map.put(acc, :current, id)
  def sum_minutes({_, _, minute, :asleep}, %{:current => _} = acc), do: Map.put(acc, :asleep, minute)
  def sum_minutes({_, _, minute, :awake}, %{:current => _} = acc), do: add_minutes(acc, Map.get(acc, :asleep), minute - 1)

  def add_minutes(acc, start, stop) do
    id = Map.get(acc, :current)
    minutes = for minute <- start..stop, do: minute
    minutes
    |> Enum.reduce(acc, fn x, map -> Map.update(map, {id, x}, 1, &(&1+1)) |> Map.update(id, 1, &(&1+1)) end)
  end

  def most_asleep_on_minute(list) do
    accumulated_minutes = Enum.reduce(list, Map.new, fn x, acc -> sum_minutes(x, acc) end)

    {id, most_asleep_minute, _} = Map.to_list(accumulated_minutes) |> Enum.filter(fn {k, _} -> is_tuple(k) end) |> Enum.reduce({0, 0, 0}, fn {{id, minute}, minutes}, {_, _, a_minutes} = a -> if minutes > a_minutes do {id, minute, minutes} else a end end)
    {id, most_asleep_minute}
  end

  def solution do
    IO.puts("#{from_file("day4_input.txt") |> most_asleep |> (fn {id, minute} -> id * minute end).()}")
    IO.puts("#{from_file("day4_input.txt") |> most_asleep_on_minute |> (fn {id, minute} -> id * minute end).()}")
  end
end
