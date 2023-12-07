defmodule Day04Card do
  defstruct [:id, :winning_numbers, :card_numbers]

  def new(string) do
    # Example: "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
    ["Card " <> id, rest] = String.split(string, ":")
    [winning_numbers, card_numbers] = String.split(rest, " | ")
    %Day04Card{
      id: String.to_integer(String.trim(id)), 
      winning_numbers: split_numbers(winning_numbers),
      card_numbers: split_numbers(card_numbers)
    }
  end

  def split_numbers(string) do
    string
    |> String.split(" ")
    |> Enum.filter(fn text -> text != "" end)
    |> Enum.map(&String.to_integer/1)
  end

  def score(card) do
    winning_count = card.winning_numbers
    |> Enum.filter(fn winning -> Enum.member?(card.card_numbers, winning) end)
    |> length

    case winning_count do
      0 -> 0
      _ -> trunc(:math.pow(2,winning_count - 1))
    end
  end
end

defmodule Day04 do
  def score_for_lines(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&Day04Card.new/1)
    |> Enum.map(&Day04Card.score/1)
    |> Enum.sum
  end
end