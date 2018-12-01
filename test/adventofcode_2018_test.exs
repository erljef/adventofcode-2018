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

end
