require "./input_20.cr"

def parse(puzzle)
  puzzle.split("\n\n").map do |message  |
    header, tile = message.split(":")
    id = header[5..].to_i32
    {id, tile.split("\n", remove_empty: true)}
  end 

  # [ {1951, ["###.#.###."]}, ... ]
end 

# do we know that the same border pattern exists on two and only two different tiles?
# can the same tile have two same border patterns (incl when flipped aka reversed)?

def get_borders(tile) # agnostically, without respect for which side it is 
  left_border = tile.map(&.[0]).join
  right_border = tile.map(&.[-1]).join
  og_borders = [tile.first, right_border, tile.last, left_border] # => top, right, bottom, left aka NESW (R) 
  flipped_borders = og_borders.map(&.reverse) # => flipped, NWSE (mirror image) (S)
  return og_borders.concat(flipped_borders) 
end 

def solve_part_1(puzzle)
  parsed_messages = parse(puzzle) # .size => 144
  
  # 🙏 praying that the orientation doesn't matter   
  # (see above about pattern on two diff tiles)
  borders = Hash(String, Array(Int32)).new # {"#.##." => [tile_id, ], ...}
  parsed_messages.each do |(tile_id, whole_tile)|
    get_borders(whole_tile).each do |border|
      if borders.has_key?(border)
        borders[border] = borders[border].push(tile_id)
      else 
        borders[border] = [tile_id]
      end
    end 
  end 
  

  edge_tiles = borders.select do |border, tiles|
    tiles.size == 1 
  end 

  p! edge_tiles.size # => expect 8 

  seen_tiles = Set(Int32).new
  potential_corner_tiles = Array(Int32).new
  edge_tiles.each do |border, tile|
    if seen_tiles.includes?(tile.first)
      potential_corner_tiles.push tile.first
    else 
      seen_tiles.add(tile.first)
    end 
  end 
  count_tiles = Hash(Int32, Int32).new  
  potential_corner_tiles.each do |tile_id|
    if count_tiles.has_key?(tile_id) 
      count_tiles[tile_id] += 1 
    else 
      count_tiles[tile_id] = 1 
    end 
  end 

  corners = count_tiles.select do |tile, count|
    count == 3
  end 
  # comment below in if we want to solve part 1
  # return corners.keys.map(&.to_i64).product
  # otherwise the below is for part 2 
  return corners.keys
end 

p! solve_part_1(INPUT)

def solve_part_2(puzzle)
  parsed_messages = parse(puzzle)


  borders = Hash(String, Array(Int32)).new # {"#.##." => [{tile_id, i}, ], ...}
  parsed_messages.each do |(tile_id, whole_tile)|
    get_borders(whole_tile).each_with_index do |border, i|
      if borders.has_key?(border)
        borders[border] = borders[border].push({tile_id: tile_id, side: i})
      else 
        borders[border] = [{tile_id: tile_id, side: i}]
      end
    end 
  end 

  tiles = Hash(Int32, Array( Tupule(Int32, Int32) )).new
  # {tile_id: [
  #     {neighbor_tile_id, border_tile_shares_with_neighbor}, 
  #     {neighbor_tile_id, border_tile_shares_with_neighbor}, ...
  #   ], 
  # }
  borders.values.each do |neighboring_tiles|
    next if neighboring_tiles.size == 1 
    neighbor_a = neighboring_tiles.first 
    neighbor_b = neighboring_tiles.last

    tiles[neighbor_a[:tile_id]] = neighbor_b
  end 
  
  corner = solve_part_1.first

  borders[

end 

# sides:
# 0 og top
# 1 og right  
# 2 og bottom 
# 3 og left 
# 4 flipped top 
# 5 flipped left 
# 6 flipped bottom 
# 7 flipped right 

# if we have one corners
# we dont know whether corner is really top-left, top-right, bottom-left, or bottom-right 
#   bc the image can always be rotated, and flipped.  so theres a total of 8 potential images at the end 
# 
# tile_map
# take one corner (A)
# find the two borders it shares with the other two tiles (B)
# stitch (B) tiles to (A) tile
# find the orientation of the (B) tiles relative to the og (order in the borders array)
# find the borders that (B) shares with other tiles (C) 