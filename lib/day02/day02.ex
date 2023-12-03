# Game is made up handfuls
defmodule Day02 do
  def run_part1 do
    {:ok, contents} = File.read("lib/day02/data.txt")
    total = contents
    |> String.split("\n", trim: true) \
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn game_number -> game_number != :not_valid end)
    |> Enum.sum

    IO.puts(total)
  end

  def parse_line(line) do
    [game_label, games_line] = String.split(line, ": ")
    "Game " <> game_number = game_label

    is_valid = games_line
    |> String.split("; ")
    |> Enum.all?(fn handful -> is_handful_possible(parse_handful_line(handful)) end)

    if is_valid, do: String.to_integer(game_number), else: :not_valid
  end

  # Converts a line like "8 green, 6 blue, 20 red" to {green: 8, blue: 6, red:20}
  def parse_handful_line(line) do
    line
    |> String.split(", ")
    |> Enum.map( fn chunk -> 
      [score, label] = String.split(chunk, " ")
      {String.to_atom(label), String.to_integer(score)}
    end )
    |> Enum.into(%{})
  end

  def is_handful_possible(scores) do
    expanded_scores = Map.merge(%{red: 0, green: 0, blue: 0}, scores)
    expanded_scores[:red] <= 12 && expanded_scores[:green] <= 13 && expanded_scores[:blue] <= 14
  end
end