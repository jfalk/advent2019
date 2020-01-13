defmodule GravityAssist do
  def process(input, current_position \\ 0) do
    case Enum.at(input, current_position) do
      99 ->
        input

      1 ->
        execute_int_code(input, current_position, &(&1 + &2))

      2 ->
        execute_int_code(input, current_position, &(&1 * &2))
    end
  end

  def execute_int_code(input, current_position, operation) do
    first_value = get_input_value(input, current_position + 1)
    second_value = get_input_value(input, current_position + 2)
    output_position = Enum.at(input, current_position + 3)

    List.replace_at(input, output_position, operation.(first_value, second_value))
    |> process(current_position + 4)
  end

  def get_input_value(input, position) do
    Enum.at(input, Enum.at(input, position))
  end

  def int_codes(file_name) do
    {:ok, content} = File.read(file_name)

    content
    |> String.replace("\n", "")
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(1, 12)
    |> List.replace_at(2, 2)
    |> process()
    |> IO.inspect()
  end
end

GravityAssist.int_codes(Enum.at(System.argv(), 0))
