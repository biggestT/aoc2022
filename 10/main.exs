defmodule Day do

  defp doOps(ops, x, c, s) do
    c = c + 1
    s = cond do
      rem(c - 20, 40) == 0 -> s + x * c
      true -> s
    end
    case ops do
      [] -> s
      [head | tail] ->
        case head do
          "addx " <> xadd -> doOps(["naddx " <> xadd] ++ tail, x, c, s)
          "naddx " <> xadd -> doOps(tail, x + String.to_integer(xadd), c, s)
          "noop" -> doOps(tail, x, c, s)
        end
    end
  end


  def part1(ops) do
    doOps(ops, 1, 0, 0)
  end

  def part2(_) do
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
        input
        |> String.split("\n")
    else
      _ -> :error
    end
  end

  def run do
    case input() do
      :error -> print_usage()
      lines -> run_parts_with_timer(lines)
    end
  end

  # boilerplate from https://github.com/adamu/AdventOfCode/blob/main/2022/day1.exs ###

  defp run_parts_with_timer(lines) do
    run_with_timer(1, fn -> part1(lines) end)
    run_with_timer(2, fn -> part2(lines) end)
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