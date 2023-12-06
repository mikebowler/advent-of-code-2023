defmodule Day03Spec do
  use ESpec

  context "part 1" do
    it "should chunk one line with only numbers" do
      Day03.chunk_line("..35..633.+")
      |> to(eql(["..", "35", "..", "633", ".", "+"]))
    end

    it "should tag all the chunks" do
      Day03.prepare_line(1, "..35..633.+")
      |> to(eql([
          {:digit, 2, 3, "35", 1}, 
          {:digit, 6, 8, "633", 1}, 
          {:symbol, 10, 10, "+", 1}
        ]))
    end

    it "should parse schematic" do
      schematic = """
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
        """
        # should include every number EXCEPT 114 or 58
        Day03.find_part_numbers(schematic)
        |> Enum.sort
        |> to(eql([35, 467, 592, 598, 617, 633, 664, 755]))
    end

    it "should match when symbol is above or below number" do
      a = Day03.prepare_line(1, "..a.")
      b = Day03.prepare_line(1, "..35")
      Day03.compare_two_prepared_lines(a,b)
      |> Enum.map(fn {_type, _start, _stop, chunk, _line_number} -> String.to_integer(chunk) end)
      |> to(eql([35]))
    end

    it "should match when symbol is beside number" do
      a = Day03.prepare_line(1, ".a..")
      b = Day03.prepare_line(1, "..35")
      Day03.compare_two_prepared_lines(a,b)
      |> Enum.map(fn {_type, _start, _stop, chunk, _line_number} -> String.to_integer(chunk) end)
      |> to(eql([35]))
    end

    it "should match when symbol is beside number" do
      a = Day03.prepare_line(1, "....x")
      b = Day03.prepare_line(1, "..35.")
      Day03.compare_two_prepared_lines(a,b)
      |> Enum.map(fn {_type, _start, _stop, chunk, _line_number} -> String.to_integer(chunk) end)
      |> to(eql([35]))
    end

    it "should only match once" do
      a = Day03.prepare_line(1, "..x.x")
      b = Day03.prepare_line(1, "..35.")
      Day03.compare_two_prepared_lines(a,b)
      |> Enum.map(fn {_type, _start, _stop, chunk, _line_number} -> String.to_integer(chunk) end)
      |> to(eql([35]))
    end

    it "should not match when symbol is away from" do
      a = Day03.prepare_line(1, "a...")
      b = Day03.prepare_line(1, "..35")
      Day03.compare_two_prepared_lines(a,b)
      |> to(eql([]))
    end
  end  

  context "part 2" do
  end

  context "running against prod data" do
    example "Part 1" do
      {:ok, schematic} = File.read("lib/day03/data.txt")
      Day03.find_part_numbers(schematic)
      |> Enum.sort
      |> Enum.sum
      |> to(eql(546563))
      # IO.puts("part1: #{total}")
    end

    # example "Part 2" do
    #   Day03.run_part2
    #   |> to(eql(49710))
    # end
  end 
end