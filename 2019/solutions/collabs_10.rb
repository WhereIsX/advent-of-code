####################################
#           AOC 2019/10            #
####################################
# MINASWAN == "Matz is nice and so we are nice"

require 'forwardable'

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
  def expand_radially(distance)
    min_x = x - distance
    max_x = x + distance
    min_y = y - distance
    max_y = y + distance

    distant_points = Set.new

    (min_y..max_y).each do |y|
      distant_points.add Point.new(min_x, y)
      distant_points.add Point.new(max_x, y)
    end

    (min_x...max_x).each do |x|
      distant_points.add Point.new(x, min_y)
      distant_points.add Point.new(x, max_y)
    end

    distant_points
  end

  def to_s
    "(#{x}, #{y})".rjust(10)
  end
end

class Grid
  extend Forwardable
  attr_reader :width, :height

  def initialize(input)
    @cells = {}
    lines = input.split("\n")  # => [".....##..", "..##.###", …]
    @height = lines.length
    @width = @height.zero? ? 0 : lines[0].length
    lines.each.with_index do |row, y|
      row.each_char.with_index do |char, x|
        is_asteroid = char == ASTEROID_SYMBOL
        self[Point.new(x, y)] = is_asteroid # {Point: Boolean}
      end
    end
  end

  def asteroids
    keys.select { |point| self[point] }.to_set
    # => Set{Point, Point, ...}
  end

  def max_distance
    @max_distance ||= [@width, @height].max
  end

  def_delegators :@cells, :keys, "[]".to_sym, "[]=".to_sym
end

class RayTracer
  def initialize(grid)
    @grid = grid
  end

  def find_all_visible_from start_point
    distance = 1
    visible = Set.new
    asteroids = @grid.asteroids.dup
    x, y = *start_point
    while distance < @grid.max_distance do
      # puts "expanding radially to distance #{distance}"
      distant_points = start_point.expand_radially(distance) & asteroids
      neighbors = distant_points
      neighbors.each do |neighbor|
        visible.add neighbor
        # for the neighboring asteroids check if their ray has been cached
        # if yes, remove it and mark it as invisible
        # if no, cache the ray and mark it as visible

        # remove the invisible asteroids "rays"
        # puts "finding invisible asteroids for start point (#{x}, #{y})"
        invisible_asteroids(x, y, neighbor).each do |invisible|
          asteroids.delete invisible
        end
      end

      distance += 1
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
    invisible = []
    i = 1
    loop do
      next_asteroid_x = x + dx * i
      next_asteroid_y = y + dy * i
      break if next_asteroid_x < 0
      break if next_asteroid_y < 0
      break if next_asteroid_x >= @grid.width
      break if next_asteroid_y >= @grid.height
      invisible << Point.new(next_asteroid_x, next_asteroid_y)
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
  i = 0
  all_asteroids.each do |asteroid|
    i += 1
    progress = (i.fdiv(all_asteroids.length) * 100).round(1).to_s.rjust(5)
    print "[#{progress}%]  Asteroid at #{asteroid} sees "
    visible = ray_tracer.find_all_visible_from asteroid
    printf "#{visible.size.to_s.rjust(5)} others"
    if visible.size > max_visibility
      print " [new max]\n"
      max_visibility = visible.size
      best_asteroid = asteroid
    else
      print "\n"
    end
  end
  [best_asteroid, max_visibility]
end


# 123.to_s.split("").first  # 5 seconds
# 123.digits.last           # .6s
