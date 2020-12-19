require "./input_18.cr"

example1 = "1 + 2 * 3 + 4 * 5 + 6"
example2 = "1 + (2 * 3) + (4 * (5 + 6))"
example3 = "2 * 3 + (4 * 5)" 

ans = [71, 51, 26]

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
  end.compact.sum
end

def solve_one_math_problem(problem)


  storage = Array(Tuple(Int64|Nil, Char|Nil)).new # [{1, '+'}]
  result = nil
  last_operator = nil
  problem.each_char do |char|
    # example2 = "1 + (2 * 3) + (4 * (5 + 6))"
    # ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
    case char 

    when '('
      storage.push({result, last_operator})
      last_operator = nil
      result = nil 

    when ')'
      num, op = storage.pop 

      case op
      when '*'
        if num && result
          result = result * num
        end 
      when '+'
        if num && result
        result = result + num
        end
      end 

    when '+'
      last_operator = char

    when '*' 
      last_operator = char 
      
    when .number? 
      if last_operator && result
        case last_operator
        when '*'
          result = result * char.to_i64 
        when '+'
          result = result + char.to_i64 
        end 
        last_operator = nil
      else 
        result = char.to_i64
      end

    end  

  end 
  return result
end 


def solve_part_2(puzzle)
  problems = parse(puzzle)

  problems.map do |problem|
    solve_math_problem_part_2(problem)
  end.sum
end 

def parenthesize(problem)
  # find each '+'
    # go left, if char immediately to the left is NOT ')'
    # => insert a '(' to the left of that char 
    # loop begin 
    # if the char IS a ')', then save the ')' 
    # and keep looking left until we find a '(' 
    # end 
    # once we have matched the # of '(' and ')'
    # we can insert a '(' to the left of that char 

  problem.each_char_with_index 
end 


def solve_math_problem_part_2(problem)
  loop do  
    result = problem.gsub(/\(([^()]+)\)/) { |_, match| 
      solve_with_flipped_precedence(match[1])
    }
    break if result == problem 
    problem = result 
  end
  return solve_with_flipped_precedence(problem).to_i64
end 

# does not handle parens 
def solve_with_flipped_precedence(problem)
  # solve the addition first until there are no more additions
  loop do  
    result = problem.gsub(/(\d+)\+(\d+)/) { |_, match| 
      match[1].to_i64 + match[2].to_i64 
    }
    break if result == problem 
    problem = result 
  end
  # solve the multiplication until there are no more multiplications
  loop do  
    result = problem.gsub(/(\d+)\*(\d+)/) { |_, match| 
      match[1].to_i64 * match[2].to_i64 
    }
    break if result == problem 
    problem = result 
  end

  return problem 
end 

p! solve_part_2(INPUT)


