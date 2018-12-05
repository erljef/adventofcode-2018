defmodule Adventofcode2018Test do
  use ExUnit.Case

  test "solves day 1 frequency" do
    assert Day1.frequency([+1, +1, +1]) == 3
    assert Day1.frequency([+1, +1, -2]) == 0
    assert Day1.frequency([-1, -2, -3]) == -6
  end

  test "solves day 1 first duplicate" do
    assert Day1.first_duplicate([+3, +3, +4, -2, -4]) == 10
    assert Day1.first_duplicate([-6, +3, +8, +5, -6]) == 5
    assert Day1.first_duplicate([+7, +7, -2, -7, -4]) == 14
  end

  test "calculates day 2 checksum" do
    assert Day2.checksum(["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]) == 12
  end

  test "calculates day 2 common letters" do
    assert Day2.common(["abcde", "fghij", "klmno", "pqrst", "fguij", "axcye", "wvxyz"]) == "fgij"
  end

  test "calculate day 3 overlapping area" do
    assert ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"] |> Day3.claims |> Day3.overlap == 4
  end

  test "calculate day 3 area ids without any overlap" do
    assert ["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"] |> Day3.claims |> Day3.no_overlap == 3
  end

  test "find the day 4 id and minute of the guard sleeping the most" do
    assert """
          [1518-11-01 00:00] Guard #10 begins shift
          [1518-11-01 00:05] falls asleep
          [1518-11-01 00:25] wakes up
          [1518-11-01 00:30] falls asleep
          [1518-11-01 00:55] wakes up
          [1518-11-01 23:58] Guard #99 begins shift
          [1518-11-02 00:40] falls asleep
          [1518-11-02 00:50] wakes up
          [1518-11-03 00:05] Guard #10 begins shift
          [1518-11-03 00:24] falls asleep
          [1518-11-03 00:29] wakes up
          [1518-11-04 00:02] Guard #99 begins shift
          [1518-11-04 00:36] falls asleep
          [1518-11-04 00:46] wakes up
          [1518-11-05 00:03] Guard #99 begins shift
          [1518-11-05 00:45] falls asleep
          [1518-11-05 00:55] wakes up
          """
           |> String.split("\n")
           |> Enum.filter(&(&1 != ""))
           |> Enum.map(&Day4.parse_row/1)
           |> Day4.most_asleep
           |> (fn {id, minute} -> id * minute end).() === 240
  end

  test "find the day 4 id and minute of the guard sleeping the most on a given minute" do
    assert """
          [1518-11-01 00:00] Guard #10 begins shift
          [1518-11-01 00:05] falls asleep
          [1518-11-01 00:25] wakes up
          [1518-11-01 00:30] falls asleep
          [1518-11-01 00:55] wakes up
          [1518-11-01 23:58] Guard #99 begins shift
          [1518-11-02 00:40] falls asleep
          [1518-11-02 00:50] wakes up
          [1518-11-03 00:05] Guard #10 begins shift
          [1518-11-03 00:24] falls asleep
          [1518-11-03 00:29] wakes up
          [1518-11-04 00:02] Guard #99 begins shift
          [1518-11-04 00:36] falls asleep
          [1518-11-04 00:46] wakes up
          [1518-11-05 00:03] Guard #99 begins shift
          [1518-11-05 00:45] falls asleep
          [1518-11-05 00:55] wakes up
          """
           |> String.split("\n")
           |> Enum.filter(&(&1 != ""))
           |> Enum.map(&Day4.parse_row/1)
           |> Day4.most_asleep_on_minute
           |> (fn {id, minute} -> id * minute end).() === 4455
  end

  test "day 5 react the polymer" do
    assert "dabAcCaCBAcCcaDA" |> String.graphemes |> Day5.react |> Enum.join == "dabCBAcaDA"
  end

  test "day 5 find the shortest polymer by removing one unit" do
    assert "dabAcCaCBAcCcaDA" |> String.graphemes |> Day5.shortest_polymer |> Enum.join == "daDA"
  end
end
