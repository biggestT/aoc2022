defmodule Day do

  defp dir(line) do
    case line do
      "dir " <> name -> name
      _ -> ""
    end
  end

  defp file(line) do
    digits = Regex.replace(~r/[^\d]/, line, "")
    case digits do
      "" -> 0
      digits -> String.to_integer(digits)
    end
  end

  defp ls(cmd, dirs) do
    lines = cmd |> String.split("\n")
    size = lines |> Enum.map(&file/1) |> Enum.sum()
    unks = lines |> Enum.map(&dir/1) |> Enum.filter(fn c -> c != "" end) |> Enum.count()
    newDir = %{:unks => unks, :size => size}
    {newDir, dirs}
  end

  defp cd(cmd, dirs) do
    case cmd do
      "cd .." <> _ -> {dirs |> List.first, dirs |> Enum.drop(1)}
      "cd " <> _ -> {%{:unks => -1, :size => 0}, dirs}
    end
  end

  defp calcSum(cmds, dirs, total) do
    case cmds do
      [] -> total
      [cmd | tail] ->
        {curDir, dirs} = case cmd do
          "cd" <> _ -> cd(cmd, dirs)
          "ls" <> _ -> ls(cmd, dirs)
        end
        curSize = curDir[:size]
        {dirs, total} = case dirs do
          [] -> {[curDir] ++ dirs, total}
          [prevDir | remDirs] -> case curDir[:unks] do
                    0 when (curSize > 100000) -> {[%{:unks => prevDir[:unks] - 1, :size => prevDir[:size] + curSize}] ++ remDirs, total}
                    0 -> {[%{:unks => prevDir[:unks] - 1, :size => prevDir[:size] + curSize}] ++ remDirs, total + curDir[:size]}
                                   -1 -> {dirs, total}
                                   _ -> {[curDir] ++ dirs, total}
            end
        end
#        {cmd, curDir, dirs, total} |> IO.inspect()
        calcSum(tail, dirs, total)
      end
  end

  def part1(cmds) do
    calcSum(cmds, [], 0)
  end

  def part2(cmds) do
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