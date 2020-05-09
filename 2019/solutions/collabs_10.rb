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
Point = Struct.new(:x, :y) do
  def expand_radially distance
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

    found_asteroids.to_set
  end
end

class Grid < Hash
  attr_reader :width, :height

  def initialize(input)
    super({}) # {Point: Boolean}
    lines = input.split("\n")  # => [".....##..", "..##.###", …]
    @height = lines.length
    @width = @height.zero? ? 0 : lines[0].length
    lines.each.with_index do |row, y|
      row.each_char.with_index do |char, x|
        is_asteroid = char == ASTEROID_SYMBOL
        self[Point.new(x, y)] = is_asteroid
      end
    end
  end

  def asteroids
    self.keys.select { |point| self[point] }.to_set
    # => Set{Point, Point, ...}
  end

  def max_distance
    @max_distance ||= [@width, @height].max
  end
end

class RayTracer
  def initialize(grid)
    @grid = grid
  end

  def find_all_visible_from start_point
    distance = 0
    visible = Set.new
    asteroids = grid.asteroids.dup
    loop do
      distance += 1
      neighbors = start_point.expand_radially(distance) & asteroids
      neighbors.each { |neighbor| visible.add neighbor }
      # for the neighboring asteroids check if their ray has been cached
      # if yes, remove it and mark it as invisible
      # if no, cache the ray and mark it as visible

      # remove the invisible asteroids "rays"
      neighbors.each do |neighbor|
        x, y = *start_point
        asteroids -= invisible_asteroids x, y, neighbor
      end

      break if distance >= @grid.max_distance
    end
    visible
  end

  private

  def invisible_asteroids(starting_x, starting_y, visible_asteroid)
    x, y = *visible_asteroid
    dx = x - starting_x
    dy = y - starting_y
    gcd = dx.gcd dy
    if !gcd.zero?
      dx /= gcd
      dy /= gcd
    end
    invisible = Set.new
    i = 1
    loop do
      next_x = x + dx * i
      next_y = y + dy * i
      break if next_x < 0
      break if next_y < 0
      break if next_x >= @grid.width
      break if next_y >= @grid.height
      invisible.add Point.new next_x, next_y
      i += 1
    end
    invisible
  end
end

=begin
#..Xx....x
...A......
...B..a...
.EDCG....a
..F.c.b...
.........
..efd.c.gb
.......c..
....f...c.
...e..d..c

2 2 2 2 2
2 1 1 1 2
2 1 0 1 2
2 1 1 1 2
2 2 2 2 2
=end
# radial expansion || food fill (similar to maze traversal)
# upon hitting an asteroid, we mark that ray as "taken"
# ray = linear function (mx + n) starting from start point
# loop through all asteroids behind the "taken" and mark as invis

# start with all asteroids
# remove asteroids as we "meet" them

def solve_part_one input
  grid = Grid.new input
  ray_tracer = RayTracer.new grid

  all_asteroids = grid.asteroids
  puts "we has #{all_asteroids.length} asteroids in total "
  max_visibility = 0
  best_asteroid = nil
  all_asteroids.each do |asteroid|
    puts "Checking deez asteroid #{asteroid}"
    visible = ray_tracer.find_all_visible_from asteroid
    if visible.size > max_visibility
      puts "Deez asteroid can see #{visible.size} other asteroids! Wowywow"
      max_visibility = visible.size
      best_asteroid = asteroid
    end
  end
  [best_asteroid, max_visibility]
end
