

defmodule Day05 do
  def parse_data(lines) do
    lines
    |> Enum.chunk_while(
      [],

      fn line, acc ->
        if String.contains?(line, ":") == false do
          {:cont, [line | acc]}
        else
          {:cont, Enum.reverse(acc), [line]}
        end
      end,

      fn acc ->
        {:cont, Enum.reverse(acc), []}
      end
    )
    |> Enum.filter(fn lines -> length(lines) != 0 end)
    |> Enum.map(fn lines ->
      case hd(lines) do
        "seeds: " <> rest -> parse_seeds(rest)
        _ -> parse_map(lines)
      end
    end)
    |> Map.new
  end

  def parse_seeds(line) do
    data = line
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)

    { :seeds, data }
  end

  def parse_map(lines) do
    [_, heading] = Regex.run(~r/(.+) map\:$/, hd(lines))
    data = tl(lines)
    |> Enum.map(&parse_numbers/1)

    {String.to_atom(heading), data}
  end

  def parse_numbers(line) do
    line
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  def location_for_seed(seed, data) do
    seed
    |> convert(data[:"seed-to-soil"])
    |> convert(data[:"soil-to-fertilizer"])
    |> convert(data[:"fertilizer-to-water"])
    |> convert(data[:"water-to-light"])
    |> convert(data[:"light-to-temperature"])
    |> convert(data[:"temperature-to-humidity"])
    |> convert(data[:"humidity-to-location"])
  end

  def convert(starting_number, map) do
    range_data = map
    |> Enum.find(:not_found, fn [_, source_range_start, range_length] ->
      starting_number >= source_range_start && starting_number <= source_range_start + range_length
    end)

    case range_data do
      [destination_range_start, source_range_start, _] -> starting_number - source_range_start + destination_range_start
      _ -> starting_number
    end
  end
end