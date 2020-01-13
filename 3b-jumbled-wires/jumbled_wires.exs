defmodule JumbledWires do
  def process_move({x, y}, move, total_moves) do
    {direction, spaces} = String.split_at(move, 1)
    spaces = String.to_integer(spaces)

    case direction do
      "U" -> build_wire(spaces, total_moves, fn offset -> {x, y + offset} end)
      "D" -> build_wire(spaces, total_moves, fn offset -> {x, y - offset} end)
      "R" -> build_wire(spaces, total_moves, fn offset -> {x + offset, y} end)
      "L" -> build_wire(spaces, total_moves, fn offset -> {x - offset, y} end)
    end
  end

  def build_wire(spaces, total_moves, offset) do
    Enum.map(1..spaces, fn x -> {offset.(x), total_moves + x} end)
  end

  def build_grid(wires) do
    {_, grid} =
      wires
      |> Enum.reduce(
        {{0, 0}, MapSet.new(), 0, %{}},
        fn x, {position, grid, total_moves, costs} ->
          new_wires = process_move(position, x, total_moves)
          Enum.each(new_wires, fn {position, wire_cost} -> costs = Map.put_new(costs, position, wire_cost) end)
          {List.last(new_wires), MapSet.union(MapSet.new(new_wires), grid), total_moves + length(new_wires), costs}
        end
      )

    grid
  end

  def parse_grids(file_name) do
    {:ok, content} = File.read(file_name)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> build_grid()
    end)
    |> Enum.reduce(fn x, acc -> MapSet.intersection(acc, x) end)
    |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
    |> Enum.min()
    |> IO.puts()
  end
end

JumbledWires.parse_grids(Enum.at(System.argv(), 0))
