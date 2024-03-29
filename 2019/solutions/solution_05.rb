require 'hamster'
require 'pry-nav'
require 'yard'


module AOC2019D05

  # @param intcode_string [String, #split] entire program to be executed
  # @return [Hamster::Vector] the entire program to be executed
  def parse(intcode_string)
    program = intcode_string
      .split(',')
      .collect { |num_as_str| num_as_str.to_i }
  end

  Opcode_has_num_params = Hamster::Hash[
    1   => 3,
    2   => 3,
    3   => 1,
    4   => 1,
    99  => 0
  ]

  # @return [Array]
  def get_parameters(intcode:, instruction_pointer:, opcode:, param_mode:)
    # param mode tells us pass by reference or pass by value

    if Opcode_has_num_params[opcode].nil?
      binding.pry
    end

    Opcode_has_num_params[opcode].times.collect do |i|
      off_by_one = i + 1
      param = intcode[instruction_pointer + off_by_one]

      return [param] if opcode == 3 || opcode == 4

      mode = param_mode[i]

      case mode
      when 0, nil     # position mode aka pass by reference
          intcode[param]
        when 1        # immediate mode aka value
          param
        end
    end
  end

  # @param intcode [Hamster::Vector, #get, #put] entire intcode program
  # @param instruction_pointer [Intger] index of where the current section begins
  # @return [Integer] advance instruction pointer forward by this number
  def execute_instruction(intcode, instruction_pointer)

    instructions = intcode[instruction_pointer]
    opcode = instructions % 100 # to get the number in the ones and tens place
    param_mode = instructions.digits[2..] || []
    parameters = get_parameters(
      intcode: intcode,
      instruction_pointer: instruction_pointer,
      opcode: opcode,
      param_mode: param_mode
    )

    case opcode
    when 1  # add
      write_to_address = parameters[2]
      result = parameters[0] + parameters[1]
      
      intcode[write_to_address] = result
      return [4, intcode]

    when 2  # multiply
      write_to_address = parameters[2]
      result = parameters[0] * parameters[1]
      intcode[write_to_address] = result
      return 4

    when 3  # store input in memory
      input = 1
      write_to_address = parameters[0]
      intcode[write_to_address] = input
      return [2, intcode]

    when 4  # "writes" aka #puts to output
      read_from_address = parameters[0]
      output = intcode[read_from_address]
      puts output
      return 2


    when 99
      return 99

    else
      raise "Invalid opcode: #{opcode}"

    end
  end

  def execute_program(intcode_string)
    intcode = parse(intcode_string)
    instruction_pointer = 0 # *instruction pointer*
    intcode_length = intcode.length

    advance_pointer = nil


    until instruction_pointer > intcode_length || advance_pointer == 99
      advance_pointer, intcode = *execute_instruction(intcode, instruction_pointer)
      binding.pry
      instruction_pointer += advance_pointer
    end
  end

end


include AOC2019D05

execute_program("3,225,1,225,6,6,1100,1,238,225,104,0,1102,59,58,224,1001,224,-3422,224,4,224,102,8,223,223,101,3,224,224,1,224,223,223,1101,59,30,225,1101,53,84,224,101,-137,224,224,4,224,1002,223,8,223,101,3,224,224,1,223,224,223,1102,42,83,225,2,140,88,224,1001,224,-4891,224,4,224,1002,223,8,223,1001,224,5,224,1,223,224,223,1101,61,67,225,101,46,62,224,1001,224,-129,224,4,224,1002,223,8,223,101,5,224,224,1,223,224,223,1102,53,40,225,1001,35,35,224,1001,224,-94,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,1101,5,73,225,1002,191,52,224,1001,224,-1872,224,4,224,1002,223,8,223,1001,224,5,224,1,223,224,223,102,82,195,224,101,-738,224,224,4,224,1002,223,8,223,1001,224,2,224,1,224,223,223,1101,83,52,225,1101,36,77,225,1101,9,10,225,1,113,187,224,1001,224,-136,224,4,224,1002,223,8,223,101,2,224,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1007,226,226,224,1002,223,2,223,1006,224,329,1001,223,1,223,1108,226,226,224,102,2,223,223,1006,224,344,101,1,223,223,1007,677,677,224,102,2,223,223,1006,224,359,101,1,223,223,1108,677,226,224,1002,223,2,223,1005,224,374,1001,223,1,223,7,677,226,224,102,2,223,223,1005,224,389,1001,223,1,223,1008,677,677,224,1002,223,2,223,1005,224,404,101,1,223,223,108,226,226,224,1002,223,2,223,1006,224,419,101,1,223,223,1008,226,677,224,1002,223,2,223,1006,224,434,1001,223,1,223,1107,677,226,224,1002,223,2,223,1005,224,449,101,1,223,223,1008,226,226,224,102,2,223,223,1005,224,464,1001,223,1,223,8,226,226,224,1002,223,2,223,1006,224,479,1001,223,1,223,107,226,677,224,102,2,223,223,1005,224,494,1001,223,1,223,7,226,226,224,102,2,223,223,1005,224,509,1001,223,1,223,107,226,226,224,102,2,223,223,1005,224,524,101,1,223,223,107,677,677,224,1002,223,2,223,1006,224,539,101,1,223,223,8,677,226,224,1002,223,2,223,1006,224,554,101,1,223,223,1107,677,677,224,1002,223,2,223,1005,224,569,101,1,223,223,108,226,677,224,1002,223,2,223,1006,224,584,101,1,223,223,7,226,677,224,1002,223,2,223,1005,224,599,1001,223,1,223,8,226,677,224,102,2,223,223,1006,224,614,1001,223,1,223,108,677,677,224,1002,223,2,223,1006,224,629,1001,223,1,223,1007,226,677,224,1002,223,2,223,1006,224,644,101,1,223,223,1108,226,677,224,102,2,223,223,1005,224,659,1001,223,1,223,1107,226,677,224,102,2,223,223,1006,224,674,1001,223,1,223,4,223,99,226")
