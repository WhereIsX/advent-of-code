require "./input_06.cr" 

def parse(puzzle_input)
  groups = puzzle_input.split("\n\n", remove_empty:true)

  #groups.map do |group|
  #  group.split("\n", remove_empty:true)
  #end 
end 

def solve_part_1(puzzle_input)
  groups = parse(puzzle_input)

  total_responses = 0 
  groups.each do |group|
    responses = Set(Char).new
    group.each_char do |char|
      responses.add(char) if char.ascii_letter? 
    end 
    total_responses += responses.size
  end 

  return total_responses
end 

def solve_part_2(puzzle_input)
  groups = parse(puzzle_input).map do |group|
    group.split("\n", remove_empty:true) 
  end 
  # [["abc"], ["a", "b", "c"], [], ...]
  
  total_responses = 0 
  groups.each do |group|
    responses_within_group = group.map do |individual|
      Set.new(individual.chars)
    end
    
    common_resp = responses_within_group.reduce do |acc_resp, resp|
      acc_resp & resp 
    end 
    total_responses += common_resp.size
  end 
  return total_responses 
end 

example = "
abc

a
b
c

ab
ac

a
a
a
a

b
"

puts solve_part_2(INPUT)
