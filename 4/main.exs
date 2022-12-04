defmodule Aoc do
  def to_range(range) do
    range |> String.replace("\n", "") |> String.split("-") |> Enum.map(&String.to_integer/1)
  end
  def is_contained(s1, e1, s2, e2) do
    if (s1 <= s2 and e1 >= e2) or (s2 <= s1 and e2 >= e1) do
      true
    else
      false
    end
  end
  def is_overlap(s1, e1, s2, e2) do
    if e1 < s2 or e2 < s1 do
      false
    else
      true
    end
  end
  def is_pairs(assignment_pair) do
      # Split the pair into two separate ranges
      [range1, range2] = String.split(assignment_pair, ",")
      [s1, e1] = to_range(range1)
      [s2, e2] = to_range(range2)

      if is_overlap(s1, e1, s2, e2) do
        1
      else
        0
      end
  end
end

pairs = File.stream!("input")
|> Stream.map(fn line -> Aoc.is_pairs(line) end)
|> Enum.to_list()
|> Enum.reduce(fn x, acc -> x + acc end)

IO.puts(pairs)