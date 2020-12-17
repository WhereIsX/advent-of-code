require "./input_14.cr"
example = "
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"
example2 = "
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"

def parse(puzzle_input)
  puzzle_input.split("mask = ", remove_empty: true).map do |mask_and_mems|
    mask = mask_and_mems[0..35]
    mems = mask_and_mems.scan(/mem\[(?<mem_addr>\d+)\] = (?<mem_val>\d+)/)
      .map{ |match| match.named_captures }
    {mask: mask, mems: mems}
  end 
end 

def solve_part_1(puzzle_input)
  instructions = parse(puzzle_input)
  memory = Hash(String, Int64).new


  instructions.each do |mask_and_mems|
    mask = mask_and_mems[:mask]
    mems = mask_and_mems[:mems]

    mems.each do |mem|

      addr = mem["mem_addr"]?
      val = mem["mem_val"]?
      next unless val && addr # to pacify compiler regarding nils 
      value_as_binary = val.to_i.to_s(2).chars 
      
      # padding value
      until value_as_binary.size == 36 
        value_as_binary.unshift '0'
      end

      # why does the compiler complain of val, addr being nil 
      # but does not whine @ mask being nil? (call #chars on mask below)
      result = mask.chars.zip(value_as_binary).map do |mask_char, value_char|
        if mask_char == 'X' 
          value_char
        else 
          mask_char 
        end 
      end 

      memory[addr] = result.join.to_i64(2)
    end 
  end 

  return memory.each_value.sum 
end 


def solve_part_2(puzzle_input)
  instructions = parse(puzzle_input)
  memory = Hash(Int64, Int64).new

  instructions.each do |mask_and_mems|
    mask = mask_and_mems[:mask]
    mems = mask_and_mems[:mems]

    mems.each do |mem|
      addr = mem["mem_addr"]?
      val = mem["mem_val"]?
      next unless mask && addr && val # to pacify compiler regarding nils 
      
      address_as_binary = addr.to_i.to_s(2).chars
      # padding addr  
      until address_as_binary.size == 36 
        address_as_binary.unshift '0'
      end

      unpermutated_address = mask.chars.zip(address_as_binary).map do |mask_char, address_char|
        case mask_char 
        when '0' 
          address_char
        when '1' 
          '1'
        when 'X'
          'X'
        end 
      end 

      generate_addresses(unpermutated_address).each do |address|
        memory[address] = val.to_i64
      end  
    end 
  end 

  return memory.each_value.sum 
end

def generate_addresses(address) 
  # address is a Map of Chars
  x_count = address.count('X')
  permutation_count = 2 ** x_count
  (0...permutation_count).map do |base_ten_number|
    # base_ten_numbers 0 => 1 => 2 => 3 
    # convert base_ten_number to binary 
    # X1101X
    # subsitute the X for the digit in the binary 
    
    binary_num = base_ten_number.to_s(2).chars 
    until binary_num.size >= x_count
      binary_num.unshift '0'
    end 

    bit_location = -1
    address.map do |address_char|
      if address_char == 'X'  
        binary_num[bit_location += 1]
      else
        address_char 
      end 
    end.join.to_i64(2)
  end 
  # returns [55, 12]
end 

p! solve_part_2(INPUT)