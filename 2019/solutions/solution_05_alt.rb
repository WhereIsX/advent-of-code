require 'pry-nav'

module AOC2019D05

  # @return [Array] intcode
  def parse(intcode_string)
    return intcode_string.split(",").collect { |num| num.to_i }
  end

  # @return [Array] opcode, and param mode
  def get_instructions(intcode, pointer)
    instructions = intcode[pointer]
    opcode = instructions % 100
    param_modes = instructions.digits[2..] || []
        # 102.digits() => [2, 0, 1]
    return [opcode, param_modes]
  end

  # @return [Array] values of parameters
  def get_params(intcode, pointer)
    opcode, param_modes = *get_instructions(intcode, pointer)

    case opcode

    when 3
      return [ intcode[pointer + 1] ]
    when 4
      value = intcode[pointer + 1]
      if param_modes.first == 0  || param_modes.empty?  # position
        return intcode[value]
      elsif param_modes.first == 1 # "immediate" aka value
        return value
      end


    when 1, 2, 5, 6, 7, 8
      ret = 2.times.collect do |i|
        params_pointer = pointer + 1 + i
        value = intcode[params_pointer]
        param_mode = param_modes[i]

        if param_mode == 0  || param_mode.nil?  # position
          intcode[value]
        elsif param_mode == 1 # "immediate" aka value
          value
        end
      end
      ret.push intcode[pointer + 3]

      return ret

    when 99
      return []

    else
      raise "invalid opcode"
    end
  end


  # @return [Intger] advance pointer by units
  def execute_instruction(intcode, pointer)
    opcode, param_mode = *get_instructions(intcode, pointer)
    params = get_params(intcode, pointer)

    case opcode
    when 1 # add
      intcode[params[2]] = params[0] + params[1]
      return 4

    when 2 # multiply
      intcode[params[2]] = params[0] * params[1]
      return 4

    when 3 # input
      puts "input please:"
      input = gets.chomp.to_i
      intcode[params[0]] = input
      return 2

    when 4 # ouput
      output = params[0]
      puts output
      return 2

    when 5  # jump if true
      if !params[0].zero?
        new_pointer_loc = params[1]
        return new_pointer_loc - pointer
      else
        return 3
      end

    when 6 # jump if false
      if params[0].zero?
        new_pointer_loc = params[1]
        return new_pointer_loc - pointer
      else
        return 3
      end

    when 7  # less than
      if params[0] < params[1]
        intcode[params[2]] = 1
      else
        intcode[params[2]] = 0
      end
      return 4

    when 8  # equals

      if params[0] == params[1]
        intcode[params[2]] = 1
      else
        intcode[params[2]] = 0
      end
      return 4

      # Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
      # Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.

    when 99
      return nil
    end

  end

  def execute_program(intcode_string)
    pointer = 0
    intcode = parse(intcode_string)

    until pointer >= intcode.length
      binding.pry
      adv_pointer = execute_instruction(intcode, pointer)
      break if adv_pointer.nil?
      pointer += adv_pointer
    end

    intcode
  end

end

include AOC2019D05

# example1 = "1002,4,3,4,33"
# example2 = "1101,100,-1,4,0"
# intcode1 = parse(example1)
# intcode2 = parse(example2)
#
# puts "\ntest: parse"
# puts parse(example1) == [1002,4,3,4,33]
# puts parse(example2) == [1101,100,-1,4,0]
#
#
# puts "\ntest: get_instructions"
# puts get_instructions(intcode1, 0) == [2, [0,1]]
# puts get_instructions(intcode2, 0) == [1, [1,1]]
#
#
# puts "\ntest: get_params"
# puts get_params(intcode1, 0) == [33, 3, 4]
# puts get_params(intcode2, 0) == [100, -1, 4]
#
# p execute_program(example1) == [1002, 4, 3, 4, 99]
# p execute_program(example2) == [1101, 100, -1, 4, 99]

example4 = '3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9'
example5 = '3,3,1105,-1,9,1101,0,0,12,4,12,99,1'
example6 = '3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99'

# # equals
# example7 = '1108, 9, 9, 0, 99'
# example8 = '0008, 0, 0, 0, 99'
# example9 = '0008, 0, 1, 0, 99'
# p execute_program(example7)
# p execute_program(example8)
# p execute_program(example9)
#
# # less than
# example10 = '1107, 1, 2, 0, 99'
# example11 = '1107, 2, 1, 0, 99'
# example12 = '1107, 2, 2, 0, 99'
# puts "\n"
# p execute_program(example10)
# p execute_program(example11)
# p execute_program(example12)
#
# example13 = '0007, 1, 0, 0, 99'
# example14 = '0007, 1, 1, 0, 99'
# p execute_program(example13)
# p execute_program(example14)


# execute_program(example4)
# execute_program(example5)
execute_program(example6)


# execute_program("3,225,1,225,6,6,1100,1,238,225,104,0,1102,59,58,224,1001,224,-3422,224,4,224,102,8,223,223,101,3,224,224,1,224,223,223,1101,59,30,225,1101,53,84,224,101,-137,224,224,4,224,1002,223,8,223,101,3,224,224,1,223,224,223,1102,42,83,225,2,140,88,224,1001,224,-4891,224,4,224,1002,223,8,223,1001,224,5,224,1,223,224,223,1101,61,67,225,101,46,62,224,1001,224,-129,224,4,224,1002,223,8,223,101,5,224,224,1,223,224,223,1102,53,40,225,1001,35,35,224,1001,224,-94,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,1101,5,73,225,1002,191,52,224,1001,224,-1872,224,4,224,1002,223,8,223,1001,224,5,224,1,223,224,223,102,82,195,224,101,-738,224,224,4,224,1002,223,8,223,1001,224,2,224,1,224,223,223,1101,83,52,225,1101,36,77,225,1101,9,10,225,1,113,187,224,1001,224,-136,224,4,224,1002,223,8,223,101,2,224,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1007,226,226,224,1002,223,2,223,1006,224,329,1001,223,1,223,1108,226,226,224,102,2,223,223,1006,224,344,101,1,223,223,1007,677,677,224,102,2,223,223,1006,224,359,101,1,223,223,1108,677,226,224,1002,223,2,223,1005,224,374,1001,223,1,223,7,677,226,224,102,2,223,223,1005,224,389,1001,223,1,223,1008,677,677,224,1002,223,2,223,1005,224,404,101,1,223,223,108,226,226,224,1002,223,2,223,1006,224,419,101,1,223,223,1008,226,677,224,1002,223,2,223,1006,224,434,1001,223,1,223,1107,677,226,224,1002,223,2,223,1005,224,449,101,1,223,223,1008,226,226,224,102,2,223,223,1005,224,464,1001,223,1,223,8,226,226,224,1002,223,2,223,1006,224,479,1001,223,1,223,107,226,677,224,102,2,223,223,1005,224,494,1001,223,1,223,7,226,226,224,102,2,223,223,1005,224,509,1001,223,1,223,107,226,226,224,102,2,223,223,1005,224,524,101,1,223,223,107,677,677,224,1002,223,2,223,1006,224,539,101,1,223,223,8,677,226,224,1002,223,2,223,1006,224,554,101,1,223,223,1107,677,677,224,1002,223,2,223,1005,224,569,101,1,223,223,108,226,677,224,1002,223,2,223,1006,224,584,101,1,223,223,7,226,677,224,1002,223,2,223,1005,224,599,1001,223,1,223,8,226,677,224,102,2,223,223,1006,224,614,1001,223,1,223,108,677,677,224,1002,223,2,223,1006,224,629,1001,223,1,223,1007,226,677,224,1002,223,2,223,1006,224,644,101,1,223,223,1108,226,677,224,102,2,223,223,1005,224,659,1001,223,1,223,1107,226,677,224,102,2,223,223,1006,224,674,1001,223,1,223,4,223,99,226")
