require "./input_23.cr"

ex = "389125467"
ans10 = "92658374"
ans100 = "67384529"

def parse(puzzle)
  puzzle.chars.map(&.to_i)
end 

def solve_part_1(puzzle, n)
  cups = parse(puzzle)

  current_cup = cups.first # cups identity, not its index! 

  n.times do 
    current_cup_index = find_index_of(current_cup, cups)
 

  end 

end 

def get_next_three_cups(current_cup_index, cups) 
    next_three = cups[current_cup_index + 1, 3]
    if next_three.length < 3 
      (3 - next_three.length).times do 
      
      end 
    end
end 

def find_index_of(thing, list)
  index = -1
  list.each_with_index do |element, i|
    index = i if thing == element
  end 
  raise "you wat" if index == -1 
  return index
end 


solve_part_1(ex, 1)