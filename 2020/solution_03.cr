
def parse( puzzle_input )
  rows = puzzle_input.split("\n", remove_empty: true) 
  forest = Hash(String, Char).new
  
  rows.each.with_index do |row, y|
    row.each_char.with_index do |land, x|  
      forest["x#{x}y#{y}"] = land 
    end 
  end 

  return forest 
end 

def dimensions ( puzzle_input ) 
  rows = puzzle_input.split("\n", remove_empty: true)
  max_y = rows.length - 1 
  max_x = rows[0].size - 1 

  return {max_x: max_x, max_y: max_y} 
end 

def solve_part_1( puzzle_input )
  forest = parse( puzzle_input )
  x = 0  
  y = 0
  tree_collision = 0 

  # running through the forest at +3x, +1y per "step"
  until y > max_y 
    
    land = forest["x#{x}y#{y}"] 
    if land == '#'
      tree_collision += 1
    end 

    if x + 3 > max_x
      x = ((x+3) % max_x ) - 1
    else
      x += 3
    end 

    y += 1 

  end 

end 


example = "
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"


f = parse( example ) 
puts "parse accurately parses the forest"
puts f["x0y0"] == '.'
puts f["x3y1"] == '.'
puts f["x6y2"] == '#'
puts "------\n"


