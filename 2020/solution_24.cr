require "./input_24.cr"

ex = "
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
"

DIRECTIONS = Set{"se", "sw", "ne", "nw", "w", "e"}

def parse(puzzle)
  puzzle.split("\n", remove_empty: true)
end 

def solve_part_1(puzzle)
  instructions = parse(puzzle)

  # axial coordinates aka next row is always shifted down & right
  hex_grid = Hash(Tuple(Int32, Int32), Bool).new do |hash, key|
    hash[key] = false # false == white; true == black
  end 

  instructions.each do |instruction|
    walk_and_mark_tiles(instruction, hex_grid)
  end

  return count_all_true_tiles(hex_grid)
end 

def count_all_true_tiles(hex_grid)
  hex_grid.values.count(true)
end 

def walk_and_mark_tiles(instruction, hex_grid) 
  # hex_grid => Hash(Tuple(Int32, Int32),Char)
  path = parse_path_from_string(instruction) # ["w", "se", "w", "e", "e", ...]
  x, y = 0, 0
  path.each do |stepp|
    case stepp
    when "ne"
      y -= 1
      x += 1
    when "nw"
      y -= 1
    when "se"
      y += 1
    when "sw"
      y += 1
      x -= 1 
    when "w"
      x -= 1
    when "e"
      x += 1
    else 
      raise "you wat" 
    end 
  end 
  tile_state = hex_grid[{x, y}] 
  hex_grid[{x, y}] = !tile_state
end 

  
def parse_path_from_string(instruction)
  path = Array(String).new
  i = 0 
  while i < instruction.size
    da_way = instruction[i, 2] 
    if DIRECTIONS.includes? da_way 
      path << da_way 
      i += 2 
    else 
      path << da_way[0].to_s 
      i += 1
    end 
  end
  return path
end 

# theres another way to parse the coordinates with no south or north ? 

p! solve_part_1(INPUT)