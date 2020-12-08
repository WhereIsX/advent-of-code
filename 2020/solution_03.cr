require "./input_03.cr"

def parse( puzzle_input : String )
  rows = puzzle_input.split("\n", remove_empty: true) 
  forest = Hash(String, Char).new
  
  rows.each.with_index do |row, y|
    row.each_char.with_index do |land, x|  
      forest["x#{x}y#{y}"] = land 
    end 
  end 

  return forest 
end 

def get_dimensions ( puzzle_input : String ) 
  rows = puzzle_input.split("\n", remove_empty: true)
  max_y = rows.size - 1 
  max_x = rows[0].size - 1 

  return {max_x: max_x, max_y: max_y} 
end 

def solve_part_1( puzzle_input : String ): Int32
  forest = parse( puzzle_input )
  dimensions = get_dimensions( puzzle_input ) 
  max_x = dimensions[:max_x] 
  max_y = dimensions[:max_y] 

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
  
  tree_collision
end 

def solve_for_slope( puzzle_input : String, slope : NamedTuple(dx: Int32, dy: Int32) ) : Int32
  forest = parse( puzzle_input )
  dimensions = get_dimensions( puzzle_input ) 
  max_x = dimensions[:max_x] 
  max_y = dimensions[:max_y] 

  x = 0  
  y = 0
  tree_collision = 0 


  # running through the forest at +3x, +1y per "step"
  until y > max_y
    land = forest["x#{x}y#{y}"] 
    if land == '#'
      tree_collision += 1
    end 

    if x + slope[:dx] > max_x
      x = ((x + slope[:dx]) % max_x ) - 1
    else
      x += slope[:dx]
    end 

    y += slope[:dy]
  end 

  tree_collision
end 

def solve_part_2( puzzle_input )
  slopes = [
    {dx: 1, dy: 1},
    {dx: 3, dy: 1},
    {dx: 5, dy: 1},
    {dx: 7, dy: 1},
    {dx: 1, dy: 2},
  ]

  tree_collisions = slopes.map do |slope|
    solve_for_slope(puzzle_input, slope).to_i64
  end
  total_collisions = tree_collisions.reduce { |acc , i| acc * i }
  return total_collisions
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

# this is crystal built-in testing
require "spec"

RUN_TESTS_PART1 = false
describe "Part 1" do
  if RUN_TESTS_PART1
    describe "parse" do
      it "accurately parses the forest" do
        f = parse( example ) 
        f["x0y0"].should eq '.'
        f["x3y1"].should eq '.'
        f["x6y2"].should eq '#'
      end
    end

    describe "solution" do
      it "correctly reports the number of tree-collisions" do
        #puts solve_part_1(example)
        # 7
      end

      it "correctly reports the number of tree-collisions for the input" do
        #puts solve_part_1(INPUT)
        # 230
      end
    end
  end
end

RUN_TESTS_PART2 = true
describe "Part 2" do
  if RUN_TESTS_PART2
    describe "slope" do
      it "correctly calculates collisions for an example" do
        solve_for_slope(example, {dx: 1, dy: 1}).should eq 2
        solve_for_slope(example, {dx: 3, dy: 1}).should eq 7
        solve_for_slope(example, {dx: 5, dy: 1}).should eq 3
        solve_for_slope(example, {dx: 7, dy: 1}).should eq 4
      end
    end

    describe "solution" do
      it "correctly calculates solution for an example" do
        solve_part_2(example).should eq 336
      end

      it "correctly calculates solution for the input" do
        solve_part_2(INPUT).should eq 9533698720
      end
    end
  end
end



# i already found the docs, but this looks too much
# like ruby 
# => "looks too much like ruby" isn't that great? 
  # => no :)
# docs are here => crystal-lang.org :] 