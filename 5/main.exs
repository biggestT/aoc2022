defmodule Day do
  def parseStackRow(row) do
    row
    |> Stream.unfold(&String.split_at(&1, 4))
    |> Enum.take_while(&(&1 != ""))
    |> Enum.map(&Regex.replace(~r/[\[\]]/u, &1, ""))
    |> Enum.map(&String.trim/1)
    |> Enum.with_index()
    |> Enum.filter(fn {v, _} -> v != "" && Regex.match?(~r/[A-Z]/, v) end)
  end

  def parseStacks(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parseStackRow/1)
    |> List.flatten()
    |> Enum.group_by(fn {_, s} -> s end, fn {l, _} -> l end)
    |> IO.inspect()
  end

  def parseMoves(input) do
    input
    |> String.split("\n")
    |> IO.inspect()
  end

  def part1(_stacksTxt, _movesTxt) do
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      [stacksTxt, movesTxt] = input
      |> String.split("\n\n")
      |> Enum.take(2)
      [_stacks, _moves] = [parseStacks(stacksTxt), parseMoves(movesTxt)]
    else
      _ -> :error
    end
  end

  # boilerplate from https://github.com/adamu/AdventOfCode/blob/main/2022/day1.exs ###

  def run do
    case input() do
      :error -> print_usage()
      [stacks, moves] -> run_parts_with_timer(stacks, moves)
    end
  end

  defp run_parts_with_timer(stacks, moves) do
    run_with_timer(1, fn -> part1(stacks, moves) end)
#    run_with_timer(2, fn -> part2(input) end)
  end

  defp run_with_timer(part, fun) do
    {time, result} = :timer.tc(fun)
    IO.puts("Part #{part} (completed in #{format_time(time)}):\n")
    IO.puts("#{result}\n")
  end

  defp format_time(msec) when msec < 1_000, do: "#{msec}ms"
  defp format_time(msec) when msec < 1_000_000, do: "#{msec / 1000}ms"
  defp format_time(msec), do: "#{msec / 1_000_000}s"
  defp print_usage do
    IO.puts("Usage: elixir main.exs input_filename")
  end
end

Day.run()