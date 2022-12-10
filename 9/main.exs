defmodule Day do

  defp tailCatchup({x, y}, tpsCur, tpsNxt) do
    case tpsCur do
      [] -> tpsNxt
      [head | tail] ->
        {tx, ty} = head
        dh = x - tx
        dv = y - ty
        tp = cond do
          # horizontal catchup
          dh == 2 && dv == 0 -> {tx+1, ty}
          dh == 2 && dv == 1 -> {tx+1, ty+1}
          dh == 2 && dv == -1 -> {tx+1, ty-1}
          dh == -2 && dv == 0 -> {tx-1, ty}
          dh == -2 && dv == -1 -> {tx-1, ty-1}
          dh == -2 && dv == 1 -> {tx-1, ty+1}
          # vertical catchup
          dh == 0 && dv == 2 -> {tx, ty+1}
          dh == 1 && dv == 2 -> {tx+1, ty+1}
          dh == -1 && dv == 2 -> {tx-1, ty+1}
          dh == 0 && dv == -2 -> {tx, ty-1}
          dh == 1 && dv == -2 -> {tx+1, ty-1}
          dh == -1 && dv == -2 -> {tx-1, ty-1}
          # special
          dh == 2 && dv == 2 -> {tx+1, ty+1}
          dh == 2 && dv == -2 -> {tx+1, ty-1}
          dh == -2 && dv == 2 -> {tx-1, ty+1}
          dh == -2 && dv == -2 -> {tx-1, ty-1}
          true -> {tx, ty}
        end
        tailCatchup(tp, tail, tpsNxt ++ [tp])
    end
  end


  defp doMove(move, [head | tail]) do
    {hx, hy} = head
    hp = case move do
      "R" -> {hx+1, hy}
      "L" -> {hx-1, hy}
      "U" -> {hx, hy+1}
      "D" -> {hx, hy-1}
    end
    tps = tailCatchup(hp, tail, [])
    [hp] ++ tps
  end

  defp doMoves(moves, trace, ps) do
    case moves do
      [] -> {trace, ps}
      [head | tail] ->
        ps = doMove(head, ps)
        doMoves(tail, trace ++ [List.last(ps)], ps)
    end
  end

  defp doCmds(cmds, trace, ps) do
    case cmds do
      [] -> trace
      [head | tail] ->
        [d, n] = String.split(head, " ", trim: true)
        {tTrace, ps} = doMoves(List.duplicate(d, String.to_integer(n)), [], ps)
        doCmds(tail, trace ++ tTrace, ps)
    end
  end


  def part1(moves) do
    positions = doCmds(moves, [], List.duplicate({0, 0}, 2))
    positions |> Enum.uniq() |> Enum.count()
  end

  def part2(moves) do
    positions = doCmds(moves, [], List.duplicate({0, 0}, 10))
    positions |> Enum.uniq() |> Enum.count()
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