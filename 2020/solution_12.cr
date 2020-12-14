require "./input_12.cr"

example = "
F10
N3
F7
R90
F11
"

def parse(puzzle)
  puzzle.split("\n", remove_empty: true).map do |instruction|
    {instruction[0], instruction[1..].to_i}
  end
  # [{'F', 10}, ...]
end 

def solve_part_1(puzzle)
  instructions = parse(puzzle)

  x = 0 # E right 
  y = 0 # N up 
  orientation = 90 

  instructions.each do |opcode, arg|
    case opcode 
    when 'N'
      y += arg 
    when 'E'
      x += arg 
    when 'S' 
      y -= arg 
    when 'W' 
      x -= arg 
    when 'F' 
      case orientation % 360 
      when 0 
        y += arg
      when 90  
        x += arg
      when 180 
        y -= arg
      when 270 
        x -= arg
      end 
    when 'R' 
      orientation += arg  
    when 'L' 
      orientation -= arg 
    end 
  end 

  return x.abs + y.abs 
end 

def solve_part_2(puzzle)
  instructions = parse(puzzle)

  ship_x = 0 # E right 
  ship_y = 0 # N up 
  waypoint_x = 10  
  waypoint_y = 1 

  instructions.each do |opcode, arg|
    case opcode 
    when 'N'
      waypoint_y += arg 
    when 'E'
      waypoint_x += arg 
    when 'S' 
      waypoint_y -= arg 
    when 'W' 
      waypoint_x -= arg 
    when 'F' 
      ship_x += waypoint_x * arg 
      ship_y += waypoint_y * arg
    when 'R' 
      case arg 
      when 90
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
      when 180 
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
      when 270 
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
      end  
    when 'L' 
      case arg 
      when 90 
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
      when 180 
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
      when 270 
        waypoint_x, waypoint_y = waypoint_y, -waypoint_x
      end  
    end 
  end 
  
  return ship_x.abs + ship_y.abs
end 

p! solve_part_2(INPUT)