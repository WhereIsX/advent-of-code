####################################
#           AOC 2019/10            #
####################################
# MINASWAN == "Matz is nice and so we are nice"

require 'rspec'

input = <<~GALAXY.chomp
...###.#########.####
.######.###.###.##...
####.########.#####.#
########.####.##.###.
####..#.####.#.#.##..
#.################.##
..######.##.##.#####.
#.####.#####.###.#.##
#####.#########.#####
#####.##..##..#.#####
##.######....########
.#######.#.#########.
.#.##.#.#.#.##.###.##
######...####.#.#.###
###############.#.###
#.#####.##..###.##.#.
##..##..###.#.#######
#..#..########.#.##..
#.#.######.##.##...##
.#.##.#####.#..#####.
#.#.##########..#.##.
GALAXY

ASTEROID_SYMBOL = '#'
Point = Struct.new(:x, :y)

# 1. parse & represent string as grid (hash or array)
grid = {} # {Point: Boolean}
input
  .split("\n")  # => [".....##..", "..##.###", …]
  .each.with_index do |row, y|
    row.each_char.with_index do |char, x|
      is_asteroid = char == ASTEROID_SYMBOL
      grid[Point.new(x, y)] = is_asteroid
    end
  end

p  grid[Point.new(1, 2)] == true
p  grid[Point.new(2, 0)] == false

# 2. for each visible asteroid,
    # calculate all other asteroids
    # remove all asteroids that are not visible



# 3. cache lines of sight
