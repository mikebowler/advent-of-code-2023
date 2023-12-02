defmodule Day01Spec do
  use ESpec

  context "part 1" do
    example "Numbers at both ends" do
      Day01.parse_line("1abc2") |> to(eql(12))
    end

    example "Two number, both in the middle" do
      Day01.parse_line("pqr3stu8vwx") |> to(eql(38))
    end
    
    example "More than two digits" do
      Day01.parse_line("a1b2c3d4e5f") |> to(eql(15))
    end

    example "Only one digit" do
      Day01.parse_line("treb7uchet") |> to(eql(77))
    end
  end  

  context "part 2" do
    example "Numbers at both ends" do
      Day01.parse_line("two1nine") |> to(eql(29))
    end

    example "Word numbers all through" do
      Day01.parse_line("eightwothree") |> to(eql(83))
    end
    
    example "Mixed" do
      Day01.parse_line("abcone2threexyz") |> to(eql(13))
    end
    
    example "Overlapping words going forward" do
      Day01.parse_line("xtwone3four") |> to(eql(24))
    end

    example "Overlapping words going backwards" do
      # This case wasn't in the provided sample data but does show up in prod data
      Day01.parse_line("x3fourtwone") |> to(eql(31))
    end

    example "Mixed" do
      Day01.parse_line("4nineeightseven2") |> to(eql(42))
    end

    example "Mixed" do
      Day01.parse_line("zoneight234") |> to(eql(14))
    end

    example "Mixed" do
      Day01.parse_line("7pqrstsixteen") |> to(eql(76))
    end
  end

  xexample "Run against prod data to get final answer" do
    Day01.run
  end


end