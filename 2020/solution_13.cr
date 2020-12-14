require "./input_13.cr"

example = "
939
7,13,x,x,59,x,31,19
"

def parse(puzzle_input)
  original_split = puzzle_input.split("\n", remove_empty: true)
  earliest_bustime = original_split.first.to_i
  buses = original_split
    .last
    .split(",")
    .reject(&.== "x")
    .map(&.to_i)
  return {earliest_bustime, buses}
end


def solve_part_1(puzzle_input)
  earliest_bustime, buses = parse(puzzle_input)

  next_bus = buses.map do |bus|
    # time from previous bus departure  
    time_since = earliest_bustime % bus

    # time until the next departure 
    {bus: bus, time_until_next: bus - time_since}
  end.min_by{ |bus| bus[:time_until_next] }

  return next_bus[:bus] * next_bus[:time_until_next]
end


p! solve_part_1(INPUT)