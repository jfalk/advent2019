defmodule JumbledWires do
  def process_move({x, y}, move) do
    {direction, spaces} = String.split_at(move, 1)
    spaces = String.to_integer(spaces)

    case direction do
      "U" -> build_wire(spaces, fn offset -> {x, y + offset} end)
      "D" -> build_wire(spaces, fn offset -> {x, y - offset} end)
      "R" -> build_wire(spaces, fn offset -> {x + offset, y} end)
      "L" -> build_wire(spaces, fn offset -> {x - offset, y} end)
    end
  end

  def build_wire(spaces, offset) do
    Enum.map(1..spaces, offset)
  end

  def build_grid(wires) do
    {_, grid} =
      wires
      |> Enum.reduce({{0, 0}, MapSet.new()}, fn x, {position, grid} ->
        new_wires = process_move(position, x)
        {List.last(new_wires), MapSet.union(MapSet.new(new_wires), grid)}
      end)

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
