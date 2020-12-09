require "./input_09.cr"

def parse(puzzle)
  puzzle.split("\n", remove_empty: true).map { |num_as_s| num_as_s.to_i64 }
end 

def solve_part_1(puzzle)
  data = parse(puzzle)

  preamble = Array(Int64).new 
  data.each do |num|
  
    if preamble.size < 25
      preamble.push(num)
    
    elsif preamble.size == 25
      sums = preamble.each_combination(2).to_a.map(&.sum)
      return num if !sums.includes?(num)
      preamble.shift && preamble.push(num)
    end 
  end   
end 

example = "
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
"

p! solve_part_1(INPUT)