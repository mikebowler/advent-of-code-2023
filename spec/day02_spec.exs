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
      Day02.parse_line(line)
      |> to(eql(3))
    end

    example "parse invalid game" do
      line = "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red"
      Day02.parse_line(line)
      |> to(eql(:not_valid))
    end
  end  

  context "part 2" do
  end

  example "Run against prod data to get final answer" do
    Day02.run_part1
  end


end