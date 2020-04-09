require 'pry-nav'

# intcode (fictional) compooper has:
# => memory (array_)
# => addresses (positions in array)
# => instructions (opcodes: 0, 1, 99),
#      which has parameters

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
      raise "Invalid opcode: #{opcode}"
    end
  end

  def execute_and_return_memory_0(intcode, noun, verb) # expect intial state
    current_section_start = 0         # *instruction pointer*
    intcode_length = intcode.length
    intcode[1] = noun
    intcode[2] = verb
    return_code = 0 # like exit codes, 0 means pass, not 0 means failure

    until current_section_start > intcode_length || return_code == 99
      return_code = execute_section(intcode, current_section_start)
      current_section_start = current_section_start + 4
    end

    return intcode.first
  end

  def solve_part_1(intcode_string, noun, verb)
    intcode = parse(intcode_string)   # *initial state*
    execute_and_return_memory_0(intcode, noun, verb)
  end

  def solve_part_2(intcode_string, expected_output)
    initial_state_intcode = parse(intcode_string)
    intcode = initial_state_intcode.clone

    # loop through all noun + verb possibilities (0-99, inclusive)
    # until output == expected_output

    (0..99).each do |noun|
      (0..99).each do |verb|
        output = execute_and_return_memory_0(intcode, noun, verb)
        if output == expected_output
          return [noun, verb]
        else
          intcode = initial_state_intcode.clone
        end
      end
    end
  end

end
