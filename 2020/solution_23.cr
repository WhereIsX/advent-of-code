# require "./input_23.cr"

ex = "389125467"
ans10 = "92658374"
ans100 = "67384529"

class Cup 
  property number, clockwise , counter_clockwise
  def initialize(@number : Int32, @clockwise : Cup | Nil = nil, @counter_clockwise : Cup | Nil = nil)
  end 

  def to_s
    puts "wat"
  end 

  def take_three_clockwise
    cups = Array(Cup).new
    cup = clockwise
    3.times do 
      if !cup.nil?
        cups.push cup
        cup = cup.clockwise 
      end  
    end 
    untaken_cup = cups.last.clockwise 
    unless untaken_cup.nil?
      @clockwise = untaken_cup
      untaken_cup.counter_clockwise = self  
    end
    return cups 
  end 

end


def parse(puzzle)
  cups = Hash(Int32, Cup).new
  puzzle.each_char do |cup|
    cup_num = cup.to_i
    cups[cup_num] = Cup.new(cup_num)
  end 
  
  puzzle.each_char_with_index do |cup, index|
    cup = cups[cup.to_i]
    counter_clockwise_cup = cups[puzzle[index - 1].to_i]

    cup.counter_clockwise = counter_clockwise_cup
    counter_clockwise_cup.clockwise = cup 
  end 
  
  first_cup = cups[puzzle[0].to_i]
  return {cups, first_cup}
  # return {Hash(Int32, Cup), first_cup}
end 

def solve_part_1(puzzle, n)
  cups, current_cup = parse(puzzle)

  n.times do 
    three_cups = current_cup.take_three_clockwise
    
  end 
  current_cup
end 

solve_part_1(ex, 0)