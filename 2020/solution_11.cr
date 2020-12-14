require "./input_11.cr"

example = "
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"

def parse(puzzle)
  puzzle.split("\n", remove_empty: true).map(&.chars)
end 

def safe_seats(row, seat)
  safe_row = row < 0 ? -8008135 : row 
  safe_seat = seat < 0 ? -8008135 : seat
  return {safe_row, safe_seat}
end 


def solve_part_1(puzzle)
  ferry_seating = parse(puzzle)
  stable = false 
  seats_occupied_last_round = -1 

  10.times do 
    # simulate rounds 
    ferry_seating = ferry_seating.map_with_index do |row, row_number|
      row.map_with_index do |seat, seat_number|

        # if this is a floor, accept a '.' to be mapped  
        if actually_a_floor?(seat)
          seat 
        else 
          # check to make sure seats are NOT out of bounds => #dig?() :>
          # check adjacent seats 
          left =        ferry_seating.dig?(*safe_seats(row_number, seat_number - 1)) 
          right =       ferry_seating.dig?(*safe_seats(row_number, seat_number + 1))
          front =       ferry_seating.dig?(*safe_seats(row_number - 1, seat_number))
          back =        ferry_seating.dig?(*safe_seats(row_number + 1, seat_number))
          front_left =  ferry_seating.dig?(*safe_seats(row_number - 1, seat_number - 1))
          front_right = ferry_seating.dig?(*safe_seats(row_number - 1, seat_number + 1))
          back_left =   ferry_seating.dig?(*safe_seats(row_number + 1, seat_number - 1))
          back_right =  ferry_seating.dig?(*safe_seats(row_number + 1, seat_number + 1))
          #    FAIRY seating    
          # *------------------*
          # | ^^^^^front^^^^^^ |
          # | left <you> right |
          # | vvvvv back vvvvv |
          # *------------------*

          adjacent_seats = {left, right, front, back, front_left, front_right, back_left, back_right} 

          get_next_seat(seat, adjacent_seats)
        end 
      end 

    end 

    print_to_terminal(ferry_seating)
    puts "\n"

    seats_occupied = ferry_seating.flatten.count('#')
    break if seats_occupied_last_round == seats_occupied
    p! seats_occupied_last_round = seats_occupied
    
  end 
  return seats_occupied_last_round
end 

def get_next_seat(seat, adjacent_seats)
  if seat == 'L' && adjacent_seats.count('#') == 0 
    return '#'
  elsif seat == '#' && too_squishy?(adjacent_seats)
    return 'L'
  else
    return seat
  end 
end 

def print_to_terminal(ferry_seating)
  
  pretty_picture = ferry_seating.map do |row|
    row.join("")
  end.join("\n")
  puts pretty_picture 
end 

def actually_a_floor?(seat)
  seat == '.'
end

def too_squishy?(adjacent_seats)  
  adjacent_seats.count('#') >= 4
end 


p! solve_part_1(example)