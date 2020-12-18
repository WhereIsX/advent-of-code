require "./input_18.cr"

example1 = "1 + 2 * 3 + 4 * 5 + 6"
example2 = "1 + (2 * 3) + (4 * (5 + 6))"
example3 = "2 * 3 + (4 * 5)" 

ans = [71, 44, 26]

def parse(puzzle)
  puzzle.split("\n", remove_empty: true).map do |line|
    line.delete(' ')
  end 
end 

# go from left to right, + and * have same precedence 
# 

def solve_part_1(puzzle)
  problems = parse(puzzle)

  problems.map do |problem|
    solve_one_math_problem(problem)
  end 
end 

def solve_one_math_problem(problem)
  p! problem

  storage = Array(Int32).new
  result = -1
  last_operator = nil
  problem.each_char do |char|

    case char 
    when '('
    when ')'
    when '+'
      last_operator = char

    when '*' 
      last_operator = char 
      
    when .number? 
      if last_operator
        case last_operator
        when '*'
          result = result * char.to_i 
        when '+'
          result = result + char.to_i 
        end 
        last_operator = nil
      else 
        result = char.to_i
      end

    end  

  end 
  return result
end 

p! solve_part_1(example1)