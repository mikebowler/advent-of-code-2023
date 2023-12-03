defmodule Day02Spec do
  use ESpec

  context "part 1" do
    example "parse one line" do
      Day02.parse_handful_line("8 green, 6 blue, 20 red")
      |> to(eql(%{green: 8, blue: 6, red: 20}))
    end

    example "Scores not possible" do
      Day02.is_handful_possible(%{green: 8, blue: 6, red: 20})
      |> to(be_false())
    end

    example "Scores possible" do
      Day02.is_handful_possible(%{green: 8, blue: 6, red: 2})
      |> to(be_true())
    end

    example "parse valid game" do
      line = "Game 3: 8 green, 6 blue, 2 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
      Day02.get_game_number_for_valid_games(line)
      |> to(eql(3))
    end

    example "parse invalid game" do
      line = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
      Day02.get_game_number_for_valid_games(line)
      |> to(eql(:not_valid))
    end
  end  

  context "part 2" do

    it "should parse game line" do
      Day02.parse_game_line("Game 3: 8 green, 6 blue, 2 red; 5 blue, 4 red, 13 green; 5 green, 1 red")
      |> to(eql({
        3, 
        [
          %{green: 8, red: 2, blue: 6},
          %{green: 13, red: 4, blue: 5},
          %{green: 5, red: 1, blue: 0}
        ]
      }))
    end

    example "cubes required" do
      Day02.cubes_required_for("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
      |> to(eql(%{green: 2, blue: 6, red: 4}))
    end
  end

  # context "running against prod data" do
  #   example "Part 1" do
  #     Day02.run_part1
  #     |> to(eql(2683))
  #   end

  #   example "Part 2" do
  #     Day02.run_part2
  #     |> to(eql(49710))
  #   end
  # end 
end