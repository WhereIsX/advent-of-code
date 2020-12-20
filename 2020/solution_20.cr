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

def get_border(tile) # agnostically, without respect for which side it is 
  left_border = tile.map(&.[0]).join
  right_border = tile.map(&.[-1]).join
  og_borders = [tile.first, right_border, tile.last, left_border] # => top, right, bottom, left aka NESW
  flipped_borders = og_borders.map(&.reverse) # => flipped, NWSE (mirror image)
  return og_borders.concat(flipped_borders) 
end 

def solve_part_1(puzzle)
  parsed_messages = parse(puzzle) # .size => 144
  
  # 🙏 praying that the orientation doesn't matter   
  # (see above about pattern on two diff tiles)
  borders = Hash(String, Array(Int32)).new # {"#.##." => [tile_id], ...}
  parsed_messages.each do |(tile_id, whole_tile)|
    get_border(whole_tile).each do |border|
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
  return corners.keys.map(&.to_i64).product
end 

p! solve_part_1(INPUT)