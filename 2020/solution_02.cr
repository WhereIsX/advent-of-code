require "./input_02.cr"


example = "
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"

def parse( puzzle_input ) 
  # [{1, 3, "a", "abcde"}, 
  #  {1, 3, "b", "cbdefg"},
  #  {2, 9, "c", "cccccccccc"},
  # ]
  parsed = [] of Tuple(Int32, Int32, String, String) 

  puzzle_input.split("\n", remove_empty: true) do |line|
    wat = line.split(/[-:\ ]/, remove_empty: true)
    parsed.push( {wat[0].to_i, wat[1].to_i, wat[2], wat[3]} )
  end 

  return parsed 
end 

def solve_part_1( puzzle_input )
  passwords_and_policies = parse( puzzle_input ) 
  valid_passwords_counter = 0 


  passwords_and_policies.each do |password_and_policy|
    min_letter = password_and_policy[0]
    max_letter = password_and_policy[1]
    required_letter = password_and_policy[2][0]
    password = password_and_policy[3]

    letter_counter = 0 
    password.each_char do |letter|
      if letter == required_letter 
       letter_counter += 1
      end 
    end 



    if (min_letter..max_letter).includes?(letter_counter) 
      valid_passwords_counter += 1 
    end 
  end 

  puts valid_passwords_counter
end

def solve_part_2( puzzle_input ) 
  passwords_and_policies = parse( puzzle_input )
  valid_passwords_counter = 0 

  passwords_and_policies.each do |password_and_policy|
    letter_pos1 = password_and_policy[0]
    letter_pos2 = password_and_policy[1] # :SeemsGood: 
    required_letter = password_and_policy[2][0]
    password = password_and_policy[3]
    valid = false
    
    # TODO: check min length D: 
    #   ^ what if pos2 is > password.length ?
    #if letter_pos2 >= password.size # .size = 5; letter_pos2 = 6, 
      #next # size and pos2 are both 1-indexed
      # i think it works without - 1 and just <
    #end
    # idk, lets ignore the indices for now
    first_matches  = password[letter_pos1 - 1] == required_letter
    second_matches = password[letter_pos2 - 1] == required_letter
    if     first_matches  && !second_matches
      valid = true
    elsif !first_matches  &&  second_matches
      valid = true
    end

    if valid
      valid_passwords_counter += 1
    end
  end 

  puts valid_passwords_counter
end

# solve_part_1( INPUT )
solve_part_2( INPUT ) 


# how does crystal store Strings? 
# => "immutable sequence" ?? 

# some more regexp
