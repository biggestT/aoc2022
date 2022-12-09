defmodule Day do

  defp newCur(cur, cmd) do
    p = cmd
    |> String.split(" ")
    |> Enum.at(1)
    case p do
      "..\n" -> cur |> Enum.drop(-1)
      c -> cur
    end
  end

  defp newSum(cmd) do
    cmd
    |> String.split("\n")
    |> Enum.map(&Regex.replace(~r/[^\d]/, &1, ""))
    |> List.flatten()
    |> Enum.filter(fn c -> c != "" end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp calcSum(cmds, cur, sums) do
    case cmds do
      [] -> sums |> IO.inspect()
      [cmd | tail] -> case String.first(cmd) do
          "c" -> calcSum(tail, newCur(cur, cmd), sums)
          "l" -> calcSum(tail, cur ++ [newSum(cmd)], sums ++ [(cur ++ [newSum(cmd)])])
        end
    end
  end

  def part1(cmds) do
    calcSum(cmds, [], [])
  end

  def part2(stream) do
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
        input
        |> String.split("$ ")
        |> Enum.drop(1)
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