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
        [{type, 0, String.length(chunk) - 1, chunk, line_number} | acc]
      else
        {_type, _start, stop, _text, _line_number} = List.first(acc)
        [{type, stop + 1, stop + String.length(chunk), chunk, line_number} | acc]
      end
    end)
    |> Enum.reverse
    |> Enum.filter(fn {type, _start, _stop, _chunk, _line_number} -> type != :none end)
  end

  # See if anything on second is affected by first. Return any part numbers. 
  def compare_two_prepared_lines(first, second) do
    second
    |> Enum.filter(fn {type, _start, _stop, _chunk, _line_number} -> type == :digit end)
    |> Enum.map(fn {type, start, stop, chunk, line_number} ->
      if any_symbols_adjacent?(start, stop, first) || any_symbols_adjacent?(start, stop, second) do
        {type, start, stop, chunk, line_number}
      else
        :none
      end
    end)
    |> Enum.filter(fn x -> x != :none end)
  end

  def any_symbols_adjacent?(number_start, number_stop, prepared_line) do
    prepared_line
    |> Enum.filter(fn {type, _start, _stop, _chunk, _line_number} -> type == :symbol end)
    |> Enum.any?(fn {_type, symbol_start, _stop, _chunk, _line_number} ->
      symbol_start >= (number_start - 1) && symbol_start <= (number_stop + 1)
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
    |> Enum.map(fn {_type, _start, _stop, chunk, _line_number} -> String.to_integer(chunk) end)
    # |> Enum.map(&String.to_integer/1)
    |> Enum.sort
  end

end
