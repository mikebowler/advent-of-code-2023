defmodule Day03Chunk do
  defstruct [:type, :start, :stop, :text, :line_number, :gears]
end

defmodule Day03 do
  defp not_none(x) do
    x != :none
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
    |> Enum.reduce([], fn text, acc ->
      type = type_of(String.first(text))
      if Enum.empty?(acc) do
        [%Day03Chunk{type: type, start: 0, stop: String.length(text) - 1, text: text, line_number: line_number} | acc]
      else
        stop = List.first(acc).stop
        [%Day03Chunk{type: type, start: stop + 1, stop: stop + String.length(text), text: text, line_number: line_number} | acc]
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
      adjacent_symbols = symbols_adjacent(chunk.start, chunk.stop, first) ++ symbols_adjacent(chunk.start, chunk.stop, second)
      if Enum.empty?(adjacent_symbols) do
        :none
      else
        # Add any gears to the chunk
        %{chunk | gears: adjacent_symbols |> Enum.filter(fn x -> x.text == "*" end)}
      end
    end)
    |> Enum.filter(&not_none/1)
  end

  def symbols_adjacent(number_start, number_stop, prepared_line) do
    prepared_line
    |> Enum.filter(fn chunk -> chunk.type == :symbol end)
    |> Enum.map(fn symbol_chunk ->
      if symbol_chunk.start >= (number_start - 1) && symbol_chunk.start <= (number_stop + 1) do
        symbol_chunk
      else
        :none
      end
    end)
    |> Enum.filter(&not_none/1)
  end

  defp process_schematic(schematic) do
    schematic
    |> String.split("\n", trim: true)
    |> Stream.with_index
    |> Enum.map(fn {line, line_number} -> prepare_line(line_number, line) end)
    |> Enum.reduce({[], []}, fn prepared_line, acc ->
      {all_parts, last_line} = acc
      { 
        compare_two_prepared_lines(prepared_line, last_line) ++
        compare_two_prepared_lines(last_line, prepared_line) ++
        all_parts, prepared_line
      }
    end)
    |> elem(0) # the accumulator
    |> Enum.uniq
  end

  def find_part_numbers(schematic) do
    process_schematic(schematic)
    |> Enum.map(fn chunk -> String.to_integer(chunk.text) end)
    |> Enum.sort
  end

  def find_gears(schematic) do
    process_schematic(schematic)
    |> Enum.filter(fn chunk -> Enum.empty?(chunk.gears) == false end)
    |> Enum.map(fn number_chunk -> for gear <- number_chunk.gears, do: {number_chunk, gear} end)# comprehensions)
    |> List.flatten
    |> Enum.group_by(
      fn {_number_chunk, gear_chunk} -> gear_chunk end,
      fn {number_chunk, _gear_chunk} -> number_chunk end
    )
    |> Enum.filter(fn {_gear_chunk, number_chunks} -> length(number_chunks) == 2 end)
    |> Enum.map(fn {_gear_chunk, number_chunks} ->
      Enum.map(number_chunks, fn number_chunk -> String.to_integer(number_chunk.text) end)
    end)
  end
end

