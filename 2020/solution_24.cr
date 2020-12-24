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
  hex_grid = get_initial_hex_grid(puzzle)
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

def get_initial_hex_grid(puzzle)
  instructions = parse(puzzle)

  # axial coordinates aka next row is always shifted down & right
  hex_grid = Hash(Tuple(Int32, Int32), Bool).new do |hash, key|
    hash[key] = false # false == white; true == black
  end 

  instructions.each do |instruction|
    walk_and_mark_tiles(instruction, hex_grid)
  end
  return hex_grid
end 

def solve_part_2(puzzle, days)
  hex_grid = get_initial_hex_grid(puzzle)


  days.times do 
    tiles_to_flip = find_all_tiles_to_flip(hex_grid)
    # apply the flip 
    tiles_to_flip.each do |tile|
      hex_grid[tile] = !hex_grid[tile]
    end 
    # count the true tiles 
    p! count_all_true_tiles(hex_grid)
  end 
end 

def find_all_tiles_to_flip(hex_grid)
#Any blk(true) tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
#Any (false) tile with exactly 2 black tiles immediately adjacent to it is flipped to black.
  tiles_to_flip = Array(Tuple(Int32, Int32)).new
  false_neighbors_of_true_tiles = Hash(Tuple(Int32, Int32), Int32).new(0)
    
  hex_grid.each do |tile_pos, tile_state|
    if tile_state # true // color is black
      neighbors = get_neighbors(tile_pos, hex_grid) # [{{Int32, Int32}, Bool}, ...]
      true_neighbors = neighbors.count{ |(_, state)| state } 
      if true_neighbors == 0 || true_neighbors > 2
        tiles_to_flip.push(tile_pos) 
      end 
      false_neighbors = neighbors.each do |(pos, state)| 
        false_neighbors_of_true_tiles[pos] += 1 if !state
      end 
    end
  end 

  false_neighbors_of_true_tiles.each do |pos, count|
    tiles_to_flip.push(pos) if count == 2 
  end 

  return tiles_to_flip # Array(Tuple(Int32, Int32))
end 




def get_neighbors(tile_pos, hex_grid)
  x, y = tile_pos

  neighbor_positions = [
    {x + 1, y -1}, 
    {x, y - 1}, 
    {x, y + 1}, 
    {x - 1, y + 1}, 
    {x + 1, y},
    {x - 1, y},
  ]

  return neighbor_positions.map do |position|
    {position, hex_grid[position]}
  end 
end 

# theres another way to parse the coordinates with no south or north ? 
solve_part_2(INPUT, 100)