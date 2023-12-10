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

  def matching_cards(card) do
    card.winning_numbers
    |> Enum.filter(fn winning -> Enum.member?(card.card_numbers, winning) end)
  end

  def score(card) do
    matching_cards = matching_cards(card)
    case matching_cards do
      0 -> 0
      _ -> trunc(:math.pow(2, length(matching_cards) - 1))
    end
  end
end

defmodule Day04 do
  def score_for_lines(lines) do
    lines
    |> Enum.map(&Day04Card.new/1)
    |> Enum.map(&Day04Card.score/1)
    |> Enum.sum
  end

  def expand_all_lines(lines) do
    cards = lines |> Enum.map(&Day04Card.new/1)
    acc = for card <- cards, into: %{}, do: {card.id, 1}
    expand(cards, acc)
  end

  def expand([], acc) do
    acc
  end

  # The acc is a map of index => quantity values
  def expand(cards, acc) do
    top_card = hd cards
    remaining_cards = tl cards

    cards_to_copy = Enum.take(tl(cards), length(Day04Card.matching_cards(top_card)))
    adjusted_quantities = for card <- cards_to_copy, into: %{}, do: {card.id, acc[card.id] + acc[top_card.id]}

    expand(remaining_cards, Map.merge(acc, adjusted_quantities, fn _k, v1, v2 -> max(v1, v2) end))
  end
end