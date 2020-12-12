example = " 
#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##
"

def parse(puzzle)
  # [ "stuff", "more stuff", "stuff", ...]
  puzzle.split("\n", remove_empty: true).map(&.chars)
end 

# remember: dont mutate this stuff
#           make new thingy from round to round
# easier to print to terminal w 2D array  
 
def solve_part_1(puzzle)

  ferry_seating = parse(puzzle)
  stable = false 
  
  5.times do 
    # simulate rounds 
    ferry_seating = ferry_seating.map.with_index(1) do |row, row_number|
      row.map.with_index(1) do |seat, seat_number|

        # if this is a floor, accept a '.' to be mapped  
        next(seat) if actually_a_floor?(seat)

        # check to make sure seats are NOT out of bounds

        # check adjacent seats 
        left =        ferry_seating.dig?(row_number, seat_number - 1) 
        right =       ferry_seating.dig?(row_number, seat_number + 1)
        front =       ferry_seating.dig?(row_number - 1, seat_number)
        back =        ferry_seating.dig?(row_number + 1, seat_number)
        front_left =  ferry_seating.dig?(row_number - 1, seat_number - 1)
        front_right = ferry_seating.dig?(row_number - 1, seat_number + 1)
        back_left =   ferry_seating.dig?(row_number + 1, seat_number - 1)
        back_right =  ferry_seating.dig?(row_number + 1, seat_number + 1)
        #     FAIRY seating 
        # *------------------*
        # | ^^^^^front^^^^^^ |
        # | left <you> right |
        # | vvvvv back vvvvv |
        # *------------------*

        adjacent_seats = {left, right, front, back, front_left, front_right, back_left, back_right} 

        too_squishy?(adjacent_seats) ? 'L' : '#'
      end 
    end 


  end 
end 

def actually_a_floor?(seat)
  seat == '.'
end

def too_squishy?(adjacent_seats)  
  adjacent_seats.count('#') >= 4
end 

# to dos 
# 1. what if its a floor seat?
# 2. index out of bounds!!!!!! :'(

["a", "b", "c"].map{|letter| return "poots" if letter == "b"  }
