defmodule Day04Spec do
  use ESpec

  context "part 1" do
    it "should initialize card" do
      Day04Card.new("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
      |> to(eq(%Day04Card{id: 1, winning_numbers: [41, 48, 83, 86, 17], card_numbers: [83, 86, 6, 31, 17, 9, 48, 53]}))
    end

    it "should calculate score when no matches" do
      Day04Card.new("Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
      |> Day04Card.score
      |> to(eq(0))
    end

    it "should calculate score when one match" do
      Day04Card.new("Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83")
      |> Day04Card.score
      |> to(eq(1))
    end

    it "should calculate score when four matches" do
      Day04Card.new("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
      |> Day04Card.score
      |> to(eq(8))
    end

    it "should handle multiple cards" do
      """
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
      """  
      |> String.split("\n", trim: true)
      |> Day04.score_for_lines
      |> to(eql(13))
    end
  end

  context "part 2" do
    it "should handle multiple cards" do
      """
        Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
        """
      |> String.split("\n", trim: true)
      |> Day04.expand_all_lines
      |> Enum.map(fn {_id, count} -> count end)
      |> Enum.sum
      |> to(eql(30))
    end
  end

  context "running against prod data" do
    example "Part 1" do
      {:ok, lines} = File.read("lib/day04/data.txt")
      lines
      |> String.split("\n", trim: true)
      |> Day04.score_for_lines
      |> to(eql(20829))
    end

    example "Part 2" do
      {:ok, lines} = File.read("lib/day04/data.txt")
      lines
      |> String.split("\n", trim: true)
      |> Day04.expand_all_lines
      |> Enum.map(fn {_id, count} -> count end)
      |> Enum.sum
      |> to(eql(12648035))
    end
  end
end