require "./input_05.cr"

examples = [
  "FBFBBFFRLR", 
  "BFFFBBFRRR", 
  "FFFBBBFRRR",
  "BBFFBBFRLL"
]

def parse( puzzle_input )
  puzzle_input.split("\n", remove_empty: true)
end 

def solve_part_1( puzzle_input )
  boarding_passes = parse(puzzle_input)
  
  highest_seat_id = 0 
  boarding_passes.each do |boarding_pass|
    row : Range(Int32, Int32)
    column : Range(Int32, Int32)

    row = 0..127
    column = 0..7  
    boarding_pass[0..6].each_char do |front_or_back|
      half_of_current_size = (row.size / 2).to_i32

      if front_or_back == 'F'
        row = (row.begin)..(row.end - half_of_current_size)
      else 
        row = (row.begin + half_of_current_size)..(row.end)
      end 
    end 

    boarding_pass[7..9].each_char do |left_or_right|
      half_of_current_size = (column.size / 2).to_i32
      if left_or_right == 'L'
        column = (column.begin)..(column.end - half_of_current_size)
      else 
        column = (column.begin + half_of_current_size)..(column.end)
      end 
    end

    if row.begin == row.end && column.begin == column.end 
      current_seat_id = (row.begin * 8) + column.begin 
      highest_seat_id = Math.max(highest_seat_id, current_seat_id)
    else 
      raise "you wat" 
    end 
  end 

  return highest_seat_id
end 

def solve_part_2(puzzle_input)
  boarding_passes = parse(puzzle_input)
  
  highest_seat_id = 0 
  seat_ids = boarding_passes.map do |boarding_pass|
    row : Range(Int32, Int32)
    column : Range(Int32, Int32)

    row = 0..127
    column = 0..7  
    boarding_pass[0..6].each_char do |front_or_back|
      half_of_current_size = (row.size / 2).to_i32

      if front_or_back == 'F'
        row = (row.begin)..(row.end - half_of_current_size)
      else 
        row = (row.begin + half_of_current_size)..(row.end)
      end 
    end 

    boarding_pass[7..9].each_char do |left_or_right|
      half_of_current_size = (column.size / 2).to_i32
      if left_or_right == 'L'
        column = (column.begin)..(column.end - half_of_current_size)
      else 
        column = (column.begin + half_of_current_size)..(column.end)
      end 
    end

    if row.begin == row.end && column.begin == column.end 
      current_seat_id = (row.begin * 8) + column.begin 
    else 
      raise "you wat" 
    end 
  end.sort

  missing_seat = [0, 0]

  seat_ids.each_cons_pair do |seat_a, seat_b|
    if seat_a + 1 != seat_b 
      missing_seat = [seat_a, seat_b]
    end 
  end 

  puts missing_seat
  return "wat"
end 


puts solve_part_2(INPUT)