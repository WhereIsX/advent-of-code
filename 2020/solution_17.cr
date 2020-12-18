require "./input_17.cr"

example = "
.#.
..#
###
"

 
def parse(puzzle)

  unpadded_puzzle = puzzle.split("\n", remove_empty: true)  # [".#.", ...]

  # padding the four sides of the puzzle so that neg indicies dont wraparound!
  padded_row = "." * (unpadded_puzzle.first.size + 2)       
  padded_puzzle = unpadded_puzzle.map do |row|
    "." + row + "."
  end.push(padded_row).unshift(padded_row)
  # padded_puzzle == [".....", "..#..", "...#.", ...]
  
  cube_world = Hash(String, Char).new 
  
  padded_puzzle.each_with_index do |row, y|
    # row == "..#.."
    row.each_char_with_index do |cube, x|
      cube_world["x#{x}y#{y}z0"] = cube
      cube_world["x#{x}y#{y}z1"] = '.'
      cube_world["x#{x}y#{y}z-1"] = '.'
    end 
  end 



  return cube_world 
end 

def find_neighbors_positions(cube_position : String)
  x, y, z = cube_position.split(/[a-z]/, remove_empty: true).map(&.to_i)

  return neighbors = [-1, 0, 1].repeated_permutations.map{ |(dx, dy, dz)|
    "x#{x + dx}y#{y + dy}z#{z + dz}"
  }.reject!(cube_position)
end 

def find_neighbors(cube_position, cube_world) : Array(Char)
  neighbors_pos = find_neighbors_positions(cube_position)
  return neighbors_pos.map do |position|
    cube_world[position]? 
  end.compact
end


def solve_part_1(puzzle)
  cube_world = parse(puzzle) 
  dimensions = puzzle.split("\n", remove_empty: true).size

  2.upto(2+5) do |i|

    cube_world = cube_world.map do |position, cube|
      neighbors = find_neighbors(position, cube_world)
      active_neighbors = neighbors.count('#')
      active_cube = cube == '#'
      if active_cube 
        meets_neighbor_requirement = 2 <= active_neighbors <= 3
        meets_neighbor_requirement ? {position, '#'} : {position, '.'}
      else 
        active_neighbors == 3 ? {position, '#'} : {position, '.'}
      end 
    end.to_h

    # pad
    (-i..(dimensions + i)).to_a.each_repeated_permutation(3) do |(x, y, z)|
      if !cube_world.has_key?("x#{x}y#{y}z#{z}")
        cube_world["x#{x}y#{y}z#{z}"] = '.'  
      end 
    end 

  end 
  
  return cube_world.values.count('#')
end 


p! solve_part_1(INPUT)


# keep a hash of all cubes 
# from each time to the next, 
#   iterate over the hash of cubes, 
#   apply game rules 

# rules: 
# If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
# If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
