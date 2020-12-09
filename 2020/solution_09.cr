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



def solve_part_2(puzzle, target_sum)
  data = parse(puzzle)

  sum_so_far = 0_i64
  first_num_pos = 0_i32 
  last_num_pos = 0_i32

  data.each.with_index do |num, i|
    sum_so_far += num 
    if sum_so_far > target_sum
      sum_so_far - data[first_num_pos]
      first_num_pos += 1 
    elsif sum_so_far == target_sum
      last_num_pos = i 
      break
    end 
  end

  preamble = data[first_num_pos..last_num_pos].sort
  return preamble.first + preamble.last 
end 


p! solve_part_2(example, 127) 
