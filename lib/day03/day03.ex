defmodule Day03Chunk do
  defstruct type: nil, start: nil, stop: nil, text: nil, line_number: nil, gear: nil
end

defmodule Day03 do
  def run_part1 do
  end

  defp type_of(element) do
    cond do
      element >= "0" && element <= "9" -> :digit
      element == "." -> :none
      true -> :symbol
    end
  end

  # breaks a line like "..35..633.+" into ["..", "35", "..", "633", ".", "+"]
  def chunk_line(line) do
    line
    |> String.graphemes
    |> Enum.chunk_while(
      [],

      fn element, acc ->
        if Enum.empty?(acc) || type_of(element) == type_of(List.first(acc)) do
          {:cont, [element | acc]}
        else
          {:cont, Enum.reverse(acc), [element]}
        end
      end,

      fn acc ->
        {:cont, Enum.reverse(acc), []}
      end
    )
    |> Enum.map(fn list -> Enum.join(list) end)
  end

  def prepare_line(line_number, line) do
    chunk_line(line)
    |> Enum.reduce([], fn chunk, acc ->
      type = type_of(String.first(chunk))
      if Enum.empty?(acc) do
        [%Day03Chunk{type: type, start: 0, stop: String.length(chunk) - 1, text: chunk, line_number: line_number} | acc]
        # [{type, 0, String.length(chunk) - 1, chunk, line_number} | acc]
      else
        stop = List.first(acc).stop
        # {_type, _start, stop, _text, _line_number} = List.first(acc)
        [%Day03Chunk{type: type, start: stop + 1, stop: stop + String.length(chunk), text: chunk, line_number: line_number} | acc]
        # [{type, stop + 1, stop + String.length(chunk), chunk, line_number} | acc]
      end
    end)
    |> Enum.reverse
    |> Enum.filter(fn chunk -> chunk.type != :none end)
  end

  # See if anything on second is affected by first. Return any part numbers. 
  def compare_two_prepared_lines(first, second) do
    second
    |> Enum.filter(fn chunk -> chunk.type == :digit end)
    |> Enum.map(fn chunk ->
      if any_symbols_adjacent?(chunk.start, chunk.stop, first) || any_symbols_adjacent?(chunk.start, chunk.stop, second) do
        chunk # %Day03Chunk{type: chunk.type, start: chunk.start, stop: chunk.stop, text: chunk.chunk, line_number: chunk.line_number}
      else
        :none
      end
    end)
    |> Enum.filter(fn x -> x != :none end)
  end

  def any_symbols_adjacent?(number_start, number_stop, prepared_line) do
    prepared_line
    |> Enum.filter(fn chunk -> chunk.type == :symbol end)
    |> Enum.any?(fn symbol_chunk ->
      symbol_chunk.start >= (number_start - 1) && symbol_chunk.start <= (number_stop + 1)
    end)
  end

  def find_part_numbers(schematic) do
    # A part number is any number adjacent to a symbol
    schematic
    |> String.split("\n", trim: true)
    |> Stream.with_index
    |> Enum.map(fn {line, line_number} -> prepare_line(line_number, line) end)
    |> Enum.reduce({[], []}, fn prepared_line, acc ->
      {all_parts, last_line} = acc
      { compare_two_prepared_lines(prepared_line, last_line) ++
        compare_two_prepared_lines(last_line, prepared_line) ++
        all_parts, prepared_line
      }
    end)
    |> elem(0) # the accumulator
    |> Enum.uniq
    |> Enum.map(fn chunk -> String.to_integer(chunk.text) end)
    # |> Enum.map(&String.to_integer/1)
    |> Enum.sort
  end

end

