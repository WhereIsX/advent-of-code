require "./input_08.cr"


def parse(puzzle)
  puzzle
    .scan(/(?<op>[a-z]{3}) (?<arg>[\+\-]\d+)\n/)
    .map { |match| match.named_captures }
end 

def solve_part_1(puzzle)
  instructions = parse(puzzle)

  accumulator = 0_i32
  instructions_executed = Set(Int32).new
  curr_instruction = 0_i32
  
  while !instructions_executed.includes?(curr_instruction)
    instructions_executed.add(curr_instruction)   
    op = instructions[curr_instruction]["op"]
    arg = instructions[curr_instruction]["arg"]
    raise "wat arg" if arg.nil? 
    arg = arg.to_i
 

    case op 
    when "nop"
      curr_instruction += 1
    when "acc"
      accumulator += arg
      # arg could be neg but + would handle this :) 
      curr_instruction += 1  
    when "jmp"
      curr_instruction += arg 
    else 
      raise "wat" 
    end 
  end 

  return accumulator
end 

def get_acc(instructions)
  accumulator = 0_i32
  curr_instruction = 0_i32
  
  while curr_instruction < instructions.size  
    op = instructions[curr_instruction]["op"]
    arg = instructions[curr_instruction]["arg"]
    raise "wat arg" if arg.nil? 
    arg = arg.to_i

    case op 
    when "nop"
      curr_instruction += 1
    when "acc"
      accumulator += arg
      curr_instruction += 1  
    when "jmp"
      curr_instruction += arg 
    end 
  end 

  return accumulator
end 

def infinite_loop?(instructions)
  instructions_executed = Set(Int32).new
  curr_instruction = 0_i32
  inf_loop_detected = false

  while curr_instruction < instructions.size  
    if instructions_executed.includes?(curr_instruction)
      inf_loop_detected = true 
      break 
    end 
    
    instructions_executed.add(curr_instruction)   
    op = instructions[curr_instruction]["op"]
    arg = instructions[curr_instruction]["arg"]
    raise "wat arg" if arg.nil? 
    arg = arg.to_i
 
    case op 
    when "nop"
      curr_instruction += 1
    when "acc"
      curr_instruction += 1  
    when "jmp"
      curr_instruction += arg 
    end 
  end
  return inf_loop_detected
end 

def solve_part_2(puzzle)
  instructions = parse(puzzle)

  instructions.each do |instruction|
    
    case instruction["op"]
    when "jmp"
      # when op is "jmp", mutate to "nop"
      instruction["op"] = "nop" 
      # if theres an infinite loop, mutate back; otherwise we found the broken instruction and want the accumulator 
      if infinite_loop?(instructions)
        instruction["op"] = "jmp"
      else 
        return get_acc(instructions)
      end 
    when "nop"
      # see above comments
      instruction["op"] = "jmp" 
      if infinite_loop?(instructions)
        instruction["op"] = "nop"
      else 
        return get_acc(instructions)
      end 
    end 
  
  end 
end 


example = "
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
" 

p! solve_part_2(INPUT) 