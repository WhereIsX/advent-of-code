require 'pry'
module AOC2019D07

  def parse(program_string)
    program = program_string
      .split(',')
      .collect { |num_as_str| num_as_str.to_i }
  end


  N_PARAMS = {
    1 => 2,
    2 => 2,
    3 => 0,
    4 => 1,
    5 => 2,
    6 => 2,
    7 => 2,
    8 => 2,
  }


  def execute_section_and_return_new_pointer(program, pointer, input)
    opcode = program[pointer] % 100

    return nil if opcode == 99 # nil breaks execute loop


    num_params = N_PARAMS[opcode]

    param_modes = program[pointer].digits[2..] || []

    # thingies to be operated on, not including write to address
    params = num_params.times.collect do |i|
      curr_param_loc = i + pointer + 1
      curr_param_mode = param_modes[i] || 0

      # 1 immediate mode (value)
      # 0 position mode (reference)
      if curr_param_mode == 0
        param = program[program[curr_param_loc]]

      elsif curr_param_mode == 1
        param = program[curr_param_loc]

      end

      param
    end

    write_to_address = program[pointer + num_params + 1]


    case opcode
    when 1 # add
      program[write_to_address] = params[0] + params[1]

      return {pointer: pointer + num_params + 2}   # 1 for instruction + 1 for write_to_address

    when 2 # multiply
      program[write_to_address] = params[0] * params[1]
      return {pointer: pointer + num_params + 2}   # 1 for instruction + 1 for write_to_address

    when 3 # input

      raise 'non nil input is expect, got nil' if input.nil?


      if input.class == Array
        binding.pry
      end


      program[write_to_address] = input
      return {pointer: pointer + 2, input_used: 1}

    when 4 # returns the output
      return {pointer: pointer + 2, output: params[0]}

    when 5 # jump if true (not zero)
      if !params[0].zero?
        return {pointer: params[1]}
      else
        return {pointer: pointer + num_params + 1}
      end

    when 6 # jump if false (eq zero)
      if params[0].zero?
        return {pointer: params[1]}
      else
        return {pointer: pointer + num_params + 1}
      end

    when 7 # less than
      if params[0] < params[1]
        program[write_to_address] = 1
      else
        program[write_to_address] = 0
      end
      return {pointer: pointer + num_params + 2}

    when 8 # equals
      if params[0] == params[1]
        program[write_to_address] = 1
      else
        program[write_to_address] = 0
      end
      return {pointer: pointer + num_params + 2}

    else
      raise 'invalid opcode'

    end
  end


  def execute_program(program_string, input=[])
    program = parse(program_string)

    input_tracker = 0
    output = []
    pointer = 0

    while pointer < program.length


      if input[input_tracker].class == Array

        binding.pry

      end


      ret = execute_section_and_return_new_pointer(program, pointer, input[input_tracker])
      break if ret.nil?
      pointer = ret[:pointer]
      input_tracker += ret.fetch(:input_used, 0)
      output << ret[:output] if ret[:output]
    end

    if output.length != 1  # for advent of code day 7 part 1, we EXPECT 1 output
      raise  "output is length #{output.length}"
    else
      return output.first
    end
  end

  # refactor parsing OUT of execute_program, and make solve_part_one parse
  # check solve_part_one function signature


  def solve_part_one(program)
    max_output = -Float::INFINITY
    # winning_phase_settings = nil

    [0,1,2,3,4].permutation.each do |phase_settings|
      # loop through all 5 amps, in which each amp:
      #   input the phase setting, and then the "input"
      #   we have the phase setting,
      #   but the "input" for each amp is the output from the last one
      #   (and we start with 0 in the first amp)
      #
      # x program
      # x phase settings
      # x inputs
      throughput = 0
      phase_settings.each do |phase_setting|
        throughput = execute_program(program, [phase_setting, throughput])
      end

      if throughput > max_output
        max_output = throughput
        # winning_phase_settings = phase_settings
      end

    end
    return max_output
  end


end


include AOC2019D07


ans1 = 43210
example1 = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
p "example 1: " +  (solve_part_one(example1) == ans1).to_s


ans2 = 54321
example2 = "3,23,3,24,1002,24,10,24,1002,23,-1,23,
101,5,23,23,1,24,23,23,4,23,99,0,0"
p "example 2: " +  (solve_part_one(example2) == ans2).to_s

ans3 = 65210
example3 = "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"
p "example 3: " +  (solve_part_one(example3) == ans3).to_s

puzzle = "3,8,1001,8,10,8,105,1,0,0,21,38,55,72,93,118,199,280,361,442,99999,3,9,1001,9,2,9,1002,9,5,9,101,4,9,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,1002,9,4,9,4,9,99,3,9,101,4,9,9,1002,9,3,9,1001,9,4,9,4,9,99,3,9,1002,9,4,9,1001,9,4,9,102,5,9,9,1001,9,4,9,4,9,99,3,9,101,3,9,9,1002,9,3,9,1001,9,3,9,102,5,9,9,101,4,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99"


p solve_part_one(puzzle)
