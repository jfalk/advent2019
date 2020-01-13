defmodule FuelCounter do
  def calculate_fuel(mass) when mass <= 0 do
    0
  end

  def calculate_fuel(mass) do
    fuel =
      [Integer.floor_div(mass, 3) - 2, 0]
      |> Enum.max()

    fuel + calculate_fuel(fuel)
  end

  def calculate_total(file_name) do
    {:ok, content} = File.read(file_name)

    content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&calculate_fuel/1)
    |> Enum.sum()
    |> IO.puts()
  end
end

FuelCounter.calculate_total(Enum.at(System.argv(), 0))
