defmodule Day01 do
  def run do
    {:ok, contents} = File.read("lib/day01/data.txt")
    total = contents
    |> String.split("\n", trim: true) \
    |> Enum.map(&parse_line/1)
    |> Enum.sum

    IO.puts(total)
  end

  def parse_line(line) do
    words = %{ 
      "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9,
      "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5,
      "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9 }

    reversed_words = for {string, value} <- words, into: %{}, do: {String.reverse(string), value}
    find_first(line, words) * 10 + find_first(String.reverse(line), reversed_words)
  end

  def find_first(line, words) do
    max_index = String.length(line)

    words
    |> Enum.map(fn {string, value} ->
      index = case :binary.match(line, string) do
        {index, _length} -> index
        :nomatch -> max_index
      end 
      {index, value}
    end)
    |> Enum.min_by(fn {index, _value} -> index end)
    |> elem(1)
  end
end