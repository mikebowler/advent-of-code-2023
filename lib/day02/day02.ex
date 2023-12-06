# Game is made up handfuls
defmodule Day02 do
  def run_part1 do
    {:ok, contents} = File.read("lib/day02/data.txt")
    total = contents
    |> String.split("\n", trim: true) \
    |> Enum.map(&get_game_number_for_valid_games/1)
    |> Enum.filter(fn game_number -> game_number != :not_valid end)
    |> Enum.sum

    IO.puts("part 1: #{total}")
    total
  end

  def run_part2 do
    {:ok, contents} = File.read("lib/day02/data.txt")
    total = contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> cubes_required_for(line) end)
    |> Enum.map(fn x -> x[:red] * x[:green] * x[:blue] end)
    |> Enum.sum

    IO.puts("part 2: #{total}")
    total
  end

  def get_game_number_for_valid_games(line) do
    {game_number, handfuls} = parse_game_line(line)

    if Enum.all?(handfuls, fn handful -> is_handful_possible(handful) end) do
      game_number
    else
      :not_valid
    end
  end

  def parse_game_line(line) do
    [game_label, games_line] = String.split(line, ": ")
    "Game " <> game_number = game_label

    handfuls = games_line
    |> String.split("; ")
    |> Enum.map(fn handful -> parse_handful_line(handful) end)

    {String.to_integer(game_number), handfuls}
  end

  # Converts a line like "8 green, 6 blue, 20 red" to {green: 8, blue: 6, red:20}
  def parse_handful_line(line) do
    scores = line
    |> String.split(", ")
    |> Enum.map(fn chunk ->
      [score, label] = String.split(chunk, " ")
      {String.to_atom(label), String.to_integer(score)}
    end )
    |> Enum.into(%{})

    Map.merge(%{red: 0, green: 0, blue: 0}, scores)
  end

  def is_handful_possible(scores) do
    scores[:red] <= 12 && scores[:green] <= 13 && scores[:blue] <= 14
  end

  defp max_value_for_key(handfuls, key) do
    handfuls
    |> Enum.map(fn x -> x[key] end)
    |> Enum.max
  end

  def cubes_required_for(game_line) do
    {_game_number, handfuls} = parse_game_line(game_line)
    %{
      blue: max_value_for_key(handfuls, :blue),
      red: max_value_for_key(handfuls, :red),
      green: max_value_for_key(handfuls, :green),
    }
  end
end