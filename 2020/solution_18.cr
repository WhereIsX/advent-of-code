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

p! solve_part_1(INPUT)