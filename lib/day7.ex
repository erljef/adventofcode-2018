defmodule Day7 do

  def from_file(path) do
    File.stream!(path)
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction(instruction) do
    {String.at(instruction, 5), String.at(instruction, 36)}
  end

  def order(instructions) do
    create_graph(instructions)
    |> next([])
    |> Enum.reverse
    |> Enum.join("")
  end

  def create_graph(instructions) do
    instructions
    |> Enum.reduce(Graph.new, fn {from, to}, graph ->
      graph |> Graph.add_vertex(from) |> Graph.add_vertex(to) |> Graph.add_edge(from, to)
    end)
  end

  def unused(graph) do
    all_unused(graph)
    |> case do
       [] -> nil
       [unused | _] -> unused
     end
  end

  def all_unused(graph) do
    graph
    |> Graph.vertices
    |> Enum.filter(&(Graph.in_degree(graph, &1) == 0))
    |> Enum.sort
  end

  def next(graph, acc) do
    if next = unused(graph) do
      next(graph |> Graph.delete_vertex(next), [next | acc])
    else
      acc
    end
  end

  def time(instructions, num_workers, base_step_time \\ 0) do
    create_graph(instructions) |> time({num_workers, %{}}, base_step_time, 0)
  end

  def time(graph, {num_workers, workers}, base_step_time, current_time) do
    available_workers = length(Map.keys(workers)) < num_workers
    current_instruction = all_unused(graph) |> Enum.filter(fn i -> is_working?(workers, i) end) |> List.first

    cond do
      available_workers && current_instruction ->
        time = instruction_time(base_step_time, current_instruction)
        workers = Map.put(workers, current_instruction, time)

        time(graph, {num_workers, workers}, base_step_time, current_time)

      Graph.vertices(graph) == [] ->
        current_time

      true ->
        workers = workers |> Enum.map(fn {i, t} -> {i, t-1} end)
        graph = workers |> Enum.reduce(graph, fn {i, t}, g ->
          if t <= 0 do
            Graph.delete_vertex(g, i)
          else
            g
          end
        end)
        workers = workers |> Enum.filter(fn {_, t} -> t > 0 end) |> Enum.into(%{})

        time(graph, {num_workers, workers}, base_step_time, current_time + 1)
    end
  end

  def is_working?(workers, instruction) do
    Map.get(workers, instruction) <= 0 || Map.get(workers, instruction) == nil
  end

  def instruction_time(base_step_time, instruction) do
    base_step_time + :binary.first(instruction) - ?A + 1
  end


  def solution do
    IO.puts("#{from_file("day7_input.txt") |> order}")
    IO.puts("#{from_file("day7_input.txt") |> time(5, 60)}")
  end
end
