defmodule Day do

  defp decode(segment, [head | tail], count) do
    cond do
      length(segment) == (segment |> Enum.uniq() |> length) -> count
      true -> decode((segment |> Enum.drop(1)) ++ [head], tail, count+1)
    end
  end

  def part1(stream) do
    segmentSize = 4
    decode(stream |> Enum.take(segmentSize), stream |> Enum.drop(segmentSize), segmentSize)
  end

  def part2(stream) do
    segmentSize = 14
    decode(stream |> Enum.take(segmentSize), stream |> Enum.drop(segmentSize), segmentSize)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
        input
        |> String.split("")
        |> Enum.drop(1)
    else
      _ -> :error
    end
  end

  def run do
    case input() do
      :error -> print_usage()
      stream -> run_parts_with_timer(stream)
    end
  end

  # boilerplate from https://github.com/adamu/AdventOfCode/blob/main/2022/day1.exs ###

  defp run_parts_with_timer(stream) do
    run_with_timer(1, fn -> part1(stream) end)
    run_with_timer(2, fn -> part2(stream) end)
  end

  defp run_with_timer(part, fun) do
    {time, result} = :timer.tc(fun)
    IO.puts("Part #{part} (completed in #{format_time(time)}):\n")
    IO.puts(result)
  end

  defp format_time(msec) when msec < 1_000, do: "#{msec}ms"
  defp format_time(msec) when msec < 1_000_000, do: "#{msec / 1000}ms"
  defp format_time(msec), do: "#{msec / 1_000_000}s"
  defp print_usage do
    IO.puts("Usage: elixir main.exs input_filename")
  end
end

Day.run()