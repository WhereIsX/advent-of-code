require "./input_01.cr"

def solution_part_1( puzzle_input )
  numbers = parse(puzzle_input)
  duckies = numbers.each_combination(2).find do |pair|
    pair[0] + pair[1] == 2020
  end
  puts duckies
  if duckies
    puts duckies[0] * duckies[1]
  else
    puts "you fucked up"
  end
end

def solution_part_2( puzzle_input )
  numbers = parse(puzzle_input)
  duckies = numbers.each_combination(3).find do |nums|
    nums[0] + nums[1] + nums[2] == 2020
  end
  puts duckies
  if duckies
    puts duckies[0] * duckies[1] * duckies[2]
  else
    puts "you fucked up"
  end
end

def parse(puzzle_input)
  pyro  = [] of Int32
  puzzle_input.split("\n", remove_empty: true) do |num_as_str|
    pyro.push( num_as_str.to_i )
  end

  return pyro
end

solution_part_2(INPUT)

# example = "
# 1721
# 979
# 366
# 299
# 675
# 1456
# "
# solution_part_2(example)
# puts "the answer for the example is: 241861950"
