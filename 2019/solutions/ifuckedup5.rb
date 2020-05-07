require 'pry'

def parse(program_string)
  program = program_string
    .split(',')
    .collect { |num_as_str| num_as_str.to_i }
end

N_PARAMS = {
  1 => 3,
  2 => 3,

}


def execute_section(program, pointer)
  opcode = program[pointer] % 100

  num_params = N_PARAMS[opcode]
  param_modes = program[pointer].digits[2..]


  params = num_params.times.collect do |i|
    curr_param_loc = i + pointer + 1
    curr_param_mode = param_modes[i]  || 0

    # 1 immediate mode (value)
    # 0 position mode (reference)
    if i + 1 == num_params
      param = program[curr_param_loc]

    elsif curr_param_mode == 0
      param = program[program[curr_param_loc]]

    elsif curr_param_mode == 1
      param = program[curr_param_loc]

    end

    param
  end




  case opcode
  when 1 # add
    program[params[2]] = params[0] + params[1]
  when 2 # multiply

  when 3
  when 4
  when 99
    puts 'program ended'
  else
    raise 'invalid opcode'
  end
end



def execute_program(program_string)

  program = parse(program_string)

  pointer = 0

  while pointer < program.length
    execute_section(program, pointer)

  end

  return executed_program
end





# TDD gods are celebrating in heaven right meow:

# TESTS
ex1 = "102,4,3,4,33"

puts execute_program(ex1)[4] == 9
