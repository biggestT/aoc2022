defmodule Day do

  defp getVisibleDirection(trees, tallest, visible) do
    case trees do
      [] -> visible
      [head | tail] when head > tallest -> getVisibleDirection(tail, head, visible ++ [1])
      [_ | tail] -> getVisibleDirection(tail, tallest, visible ++ [0])
    end
  end

  defp countVisible(trees) do
    lr = getVisibleDirection(trees, -1, [])
    rl = getVisibleDirection(trees |> Enum.reverse(), -1, []) |> Enum.reverse()
    Enum.zip_with(lr, rl, fn x, y -> max(x, y) end)
  end

  defp flip(rows) do
    numCols = rows |> List.first() |> length
    rows
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.group_by(fn {_, v} -> rem(v, numCols) end)
    |> Enum.map(fn {i, v} -> {i, v} end)
    |> Enum.sort()
    |> Enum.map(fn {_, v} -> Enum.map(v, fn {v, _} -> v end) end)
  end

  def part1(rows) do
    forest = rows |> Enum.map(fn x -> String.split(x, "", trim: true) end)

    horizontal = forest
                 |> Enum.map(fn l -> countVisible(l) end)

    vertical = forest
               |> flip()
               |> Enum.map(fn l -> countVisible(l) end)
               |> flip()


    Enum.zip_with(horizontal, vertical, fn x, y -> Enum.zip_with(x, y, fn i, j -> max(i, j) end) end)
    |> Enum.reduce(0, fn l, acc -> acc + Enum.sum(l) end)
  end

  def part2(line) do
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