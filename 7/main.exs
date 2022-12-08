defmodule Day do

  defp newPos(cmd, pos) do
    p = cmd
    |> String.split(" ")
    |> Enum.at(1)
    |> IO.inspect()
    case p do
      "..\n" -> String.slice(pos, 0..-2)
      c -> pos <> c
    end
  end

  defp newSum(cmd, pos) do
    sum = cmd
    |> String.split("\n")
    |> Enum.map(&Regex.replace(~r/[^\d]/, &1, ""))
    |> List.flatten()
    |> Enum.filter(fn c -> c != "" end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> IO.inspect()

    {pos, sum}
  end

  defp calcSum(cmds, pos, psums) do
    p = Regex.replace(~r/[^a-z]/, pos, "")
    case cmds do
      [] -> psums |> IO.inspect()
      [cmd | tail] -> case String.first(cmd) do
          "c" -> calcSum(tail, newPos(cmd, p), psums)
          "l" -> calcSum(tail, p, psums ++ [newSum(cmd, p)])
        end
    end
  end

  def part1(cmds) do
    calcSum(cmds, "", [])
  end

  def part2(stream) do
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
        input
        |> String.split("$ ")
        |> Enum.drop(1)
        |> IO.inspect()
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
#    run_with_timer(2, fn -> part2(lines) end)
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