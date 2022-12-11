defmodule Day do

  defp doOps(ops, x, c, p1, p2) do
    c = c + 1
    # part 1
    p1 = cond do
      rem(c - 20, 40) == 0 -> p1 + x * c
      true -> p1
    end
    # part 
    xpos = rem(c, 40)
    char = cond do
      x - 1 <= xpos and xpos <= x + 1 -> "#"
      true -> "."
    end
    case ops do
      [] -> {p1, p2}
      [head | tail] ->
        case head do
          "addx " <> xadd -> doOps(["naddx " <> xadd] ++ tail, x, c, p1, p2 ++ [char])
          "naddx " <> xadd -> doOps(tail, x + String.to_integer(xadd), c, p1, p2 ++ [char])
          "noop" -> doOps(tail, x, c, p1, p2 ++ [char])
        end
    end
  end


  def part1(ops) do
    {p1, _} = doOps(ops, 1, 0, 0, [])
    p1
  end

  def part2(ops) do
    {_, p2} = doOps(ops, 1, -1, 0, [])
    p2
    |> Enum.chunk_every(40)
    |> Enum.join("\n")
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