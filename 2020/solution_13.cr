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

def parse2(puzzle_input)
  original_split = puzzle_input.split("\n", remove_empty: true)

  # [{7, 0}, {13, 1}, ...]
  bus_infos = original_split
    .last
    .split(",")
    .map_with_index {|bus_id, index| {id: bus_id, index: index}}
    .reject{ |bus_info| bus_info[:id] == "x" } 
    .map{ |bus_info| {id: bus_info[:id].to_i, index: bus_info[:index]} }
  return bus_infos
end 



def solve_part_2(puzzle_input)
  # parse 
  # sort_by busid 
  # generate time using the biggest bus multiples
    # for every biggest_bus_multiple_time,
      # for every other_bus,  
        # expect (biggest_bus_multiple_time + index ) % other_bus_id == 0 
  
  bus_infos = parse2(puzzle_input).sort_by do |bus_info|
    bus_info[:id]
  end.reverse

  solution = 0_i64
  # current number that represents the multiple && location of the numbers so far 
  step_interval = 1_i64
  bus_infos.each_cons do |buses|
  
    step_interval = big_bus[:id] 
    big_bus, little_bus = *buses 
    (solution..).step(step_interval) do |


  end 
end 

awc = "
thing
5,7
"

2*  3     5
4   6     10  
6   9*    15
8*  12    20 
10  15*
12  18
14*  21
16
18
20*




5, 7 = 20 


5, 7 9 = 160 
5, 7, 9, 11

p! solve_part_2(INPUT)