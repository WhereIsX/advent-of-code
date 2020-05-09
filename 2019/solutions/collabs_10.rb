####################################
#           AOC 2019/10            #
####################################
# MINASWAN == "Matz is nice and so we are nice"

INPUT = <<~GALAXY.chomp
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

class Grid < Hash
  def initialize(input)
    super({}) # {Point: Boolean}
    input
      .split("\n")  # => [".....##..", "..##.###", …]
      .each.with_index do |row, y|
        row.each_char.with_index do |char, x|
          is_asteroid = char == ASTEROID_SYMBOL
          self[Point.new(x, y)] = is_asteroid
        end
      end
  end

  def asteroids
    grid.keys.select { |point| grid[point] }.to_set
    # => Set{Point, Point, ...}
  end
end

def get_dimensions input
  height = input.split("\n").length
  width = input.split("\n")[0].length
  puts "Width: #{width}\tHeight: #{height}"
  [width, height]
end

grid = Grid.new INPUT
WIDTH, HEIGHT = *(get_dimensions INPUT)
MAX_DISTANCE = [WIDTH, HEIGHT].max

# 2. for each asteroid
    # calculate all other asteroids
    # remove all asteroids that are not visible
all_asteroids = grid.asteroids

# radial expansion || food fill (similar to maze traversal)
# upon hitting an asteroid, we mark that ray as "taken"
# ray = linear function (mx + n) starting from start point
# loop through all asteroids behind the "taken" and mark as invis

# start with all asteroids
# remove asteroids as we "meet" them

def solve_part_one input
  grid = Grid.new input

  all_asteroids = find_asteroids grid
  puts "we has #{all_asteroids.length} asteroids in total "
  max_visibility = 0
  best_asteroid = nil
  all_asteroids.each do |asteroid|
    puts "Checking deez asteroid #{asteroid}"
    visible = find_all_visible asteroid, all_asteroids
    if visible.size > max_visibility
      puts "Deez asteroid can see #{visible.size} other asteroids! Wowywow"
      max_visibility = visible.size
      best_asteroid = asteroid
    end
  end
  [best_asteroid, max_visibility]
end

def find_all_visible(start_point, all_asteroids)
  asteroids = all_asteroids.dup
  distance = 0
  visible = Set.new
  loop do
    distance += 1
    neighbors = find_neighbors start_point, distance, asteroids
    neighbors.each { |neighbor| visible.add neighbor }
    # for the neighboring asteroids check if their ray has been cached
    # if yes, remove it and mark it as invisible
    # if no, cache the ray and mark it as visible

    # remove the invisible asteroids "rays"
    neighbors.each do |neighbor|
      x, y = *start_point
      remove_invisible_asteroids x, y, neighbor, asteroids
    end

    break if distance >= MAX_DISTANCE
  end
  visible
end

def remove_invisible_asteroids(starting_x, starting_y, visible_asteroid, asteroids)
  x, y = *visible_asteroid
  dx = x - starting_x
  dy = y - starting_y
  gcd = dx.gcd dy
  if !gcd.zero?
    dx /= gcd
    dy /= gcd
  end
  i = 1
  loop do
    next_x = x + dx * i
    next_y = y + dy * i
    break if next_x < 0
    break if next_y < 0
    break if next_x >= WIDTH
    break if next_y >= HEIGHT
    point = Point.new next_x, next_y
    asteroids.delete point
    i += 1
  end
  asteroids
end

=begin
#..X.x...x
...A......
...B..a...
.EDCG....a
..F.c.b...
.........
..efd.c.gb
.......c..
....f...c.
...e..d..c
=end



=begin
2 2 2 2 b
2 1 1 a 2
2 1 0 1 2
2 1 H 1 2
2 2 h 2 2
=end
def find_neighbors(start_point, distance, asteroids)
  x, y = *start_point
  min_x = x - distance
  max_x = x + distance
  min_y = y - distance
  max_y = y + distance

  found_asteroids = []
  (min_y..max_y).each do |y|
    found_asteroids << Point.new(min_x, y)
    found_asteroids << Point.new(max_x, y)
  end

  (min_x..max_x).each do |x|
    found_asteroids << Point.new(x, min_y)
    found_asteroids << Point.new(x, max_y)
  end

  found_asteroids.to_set & asteroids
end




=begin
'*' = places we check for asteroid
1 = visible asteroid
0 =  not visible asteroid

1.
.#..#
.....
#####
....#
...##

2.
*#*.#
.*...
#####
....#
...##

3.
.#.*#
*.*..
#*###
.x..#
.x.##

4.
.#.*#
*.*..
#*###
.x..#
.x.##
=end


# 3. cache lines of sight
