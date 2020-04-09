require 'pry-nav'

# AOC2019D02 part 2 enlightens us that this problem mimics memory (RAM)
# the *astrisked* inline comments denote the terminology if this were RAM

module AOC2019D02

  def parse(intcode_string)
    intcode_string
      .split(',')
      .collect do |num_as_str|
        num_as_str.to_i
      end
  end

  def execute_section(intcode, section_start)
    opcode = intcode[section_start]                 # *instruction*
    position_operand_a = intcode[section_start + 1] # *address* / *parameters*
    position_operand_b = intcode[section_start + 2] # *address* / *parameters*
    position_to_store_result = intcode[section_start + 3]

    case opcode
    when 1
      result = intcode[position_operand_a] + intcode[position_operand_b]
      intcode[position_to_store_result] = result
      return 0
    when 2
      result = intcode[position_operand_a] * intcode[position_operand_b]
      intcode[position_to_store_result] = result
      return 0
    when 99 # opcode 99 contains only instruction, has no parameters :D
      return 99
    else
      raise 'Invalid opcode'
    end

  end

  def solve_part_1(intcode_string)
    intcode = parse(intcode_string)   # *initial state*
    execute_and_return_memory_0(intcode)
  end

  def execute_and_return_memory_0(intcode) # expect intial state
    current_section_start = 0         # *instruction pointer*
    intcode_length = intcode.length
    return_code = 0

    until current_section_start > intcode_length || return_code == 99
      return_code = execute_section(intcode, current_section_start)
      current_section_start = current_section_start + 4
    end

    return intcode.first
  end

  # def solve_part_2()

end

include AOC2019D02


input = '1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,9,19,23,2,23,13,27,1,27,9,31,2,31,6,35,1,5,35,39,1,10,39,43,2,43,6,47,1,10,47,51,2,6,51,55,1,5,55,59,1,59,9,63,1,13,63,67,2,6,67,71,1,5,71,75,2,6,75,79,2,79,6,83,1,13,83,87,1,9,87,91,1,9,91,95,1,5,95,99,1,5,99,103,2,13,103,107,1,6,107,111,1,9,111,115,2,6,115,119,1,13,119,123,1,123,6,127,1,127,5,131,2,10,131,135,2,135,10,139,1,13,139,143,1,10,143,147,1,2,147,151,1,6,151,0,99,2,14,0,0'
