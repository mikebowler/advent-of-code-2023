defmodule Day05Spec do
  use ESpec

  context "part 1" do
    it "should parse lines into groups" do
      """
      seeds: 1 2 3

      seed-to-soil map:
      4 5 6
      7 8 9

      soil-to-fertilizer map:
      10 11 12
      13 14 15
      """
      |> String.split("\n", trim: true)
      |> Day05.parse_data
      |> to(eql(%{
          seeds: [1, 2, 3],
          "seed-to-soil": [[4, 5, 6], [7, 8, 9]],
          "soil-to-fertilizer": [[10, 11, 12], [13, 14, 15]]
        }))
    end

    context "convert" do
      # destination_range_start, source_range_start, range_length
      it "should convert when in range" do
        Day05.convert(5, [[4, 5, 6]])
        |> to(eql(4))
      end

      it "should pass through when not in range" do
        Day05.convert(3, [[4, 5, 6]])
        |> to(eql(3))
      end
    end

    context "location_for_seed" do
      lines = """
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70

        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13

        temperature-to-humidity map:
        0 69 1
        1 0 69

        humidity-to-location map:
        60 56 37
        56 93 4
        """
      # {:ok, lines} = File.read("lib/day05/data.txt")
      data = lines
      |> String.split("\n", trim: true)
      |> Day05.parse_data

      # Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
      Day05.location_for_seed(79, data)
      |> to(eql(82))

      # IO.puts("Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.")
      Day05.location_for_seed(14, data)
      |> to(eql(43))
    end
  end

  context "part 1" do
    it "should run on live data" do
      {:ok, lines} = File.read("lib/day05/data.txt")
      data = lines
      |> String.split("\n", trim: true)
      |> Day05.parse_data

      data[:seeds]
      |> Enum.map(fn x -> Day05.location_for_seed(x, data) end)
      |> Enum.min
      # |> elem(1)
      |> to(eql(535088217))
    end
  end
end




















