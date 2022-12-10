defmodule Day do

  defp doMove(move, {hx, hy}, {tx, ty}) do
    hp = case move do
      "R" -> {hx+1, hy}
      "L" -> {hx-1, hy}
      "U" -> {hx, hy+1}
      "D" -> {hx, hy-1}
    end
    dh = hx - tx
    dv = hy - ty
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
      true -> {tx, ty}
    end
    {hp, tp}
  end

  defp doMoves(moves, trace, hp, tp) do
    case moves do
      [] -> {trace, hp, tp}
      [head | tail] ->
        {hp, tp} = doMove(head, hp, tp)
        doMoves(tail, trace ++ [tp], hp, tp)
    end
  end

  defp doCmds(cmds, trace, hp, tp) do
    case cmds do
      [] -> trace
      [head | tail] ->
        [d, n] = String.split(head, " ", trim: true)
        {nTrace, hp, tp} = doMoves(List.duplicate(d, String.to_integer(n)), [], hp, tp)
        doCmds(tail, trace ++ nTrace, hp, tp)
    end
  end


  def part1(moves) do
    positions = doCmds(moves, [], {0, 0}, {0, 0})
    positions |> Enum.uniq() |> Enum.count()
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