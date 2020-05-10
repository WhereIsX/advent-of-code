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
    @asteroids = {}
    @max_x_distances = {}
    @max_y_distances = {}
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

  def max_distance_from start_point
    x, y = *start_point
    @max_x_distances[x] ||= (@width - start_point.x).abs
    @max_y_distances[y] ||= (@height - start_point.y).abs
    [@max_x_distances[x], @max_y_distances[y]].max
  end

  def_delegators :@asteroids, :keys, "[]".to_sym, "[]=".to_sym
end

class RayTracer
  def initialize(grid)
    @grid = grid
  end

  def shift_grid_relative_to(point)

  end

  def find_all_visible_from start_point
    distance = 1
    visible = Set.new
    asteroids = @grid.asteroids.dup
    x, y = *start_point
    while distance < @grid.max_distance_from(start_point) do
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
.........
.........
....o....
.........
.........
=end

class TemporaryRayTracer
  #

  def initialize grid, start_point
    @grid = grid
    @start_point = start_point
  end

  def vaporize_asteroids
    all_asteroids = @grid.asteroids
    rays = {}
    all_asteroids.each do |asteroid|
      next if start_point == asteroid
      # fill up a hash by radian

      dx = asteroid.x - @start_point.x
      dy = asteroid.y - @start_point.y
      theta = Math.atan2 -dy, dx  # betwen -PI, PI
      [0,1,2,3]
      # 0deg = 0
      # 90deg = pi/2
      # 180deg = pi        -pi
      # 270deg = 3pi/2
      # 360deg = 0
      rays[theta] ||= []
      rays[theta] << asteroid
    end
    upwards = Math::PI.fdiv 2   # the starting direction we look in (up)
    rays.sort_by! do |theta, points|
      # theta is the direction we look in to see the asteroid
      # first come those thetas that are bigger than start_angle
      diff = theta - upwards
      # lowest value needs to be returned if diff is a very small positve value
      # middle value needs to be returned if diff = PI
      # highest value needs to be returned if diff = 0
      highest_possible_diff = Math::PI.fdiv 2
      -(diff % highest_possible_diff)
      # if diff == 0 => upwards asteroid
      # next one: smallest positive diff
      # next one: highest positive diff
      # next one: is the smallest diff (highest negative value)
      # last one: is the closest negative diff to zero
      # BUT: start_angle .. .. start_angle
    end

    i = 0
    vaporized_asteroid = nil
    loop do
      rays.each do |ray|
        break if i == 200
        vaporized_asteroid = ray.shift
        next unless vaporized_asteroid
        i += 1
      end
    end

    vaporized_asteroid
    # result: array of rays (arrays of points)
    # remove first element of each ray
    # count
    # boom
  end

end


solve_part_two







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

def solve_part_two input
  best_asteroid = *(solve_part_one input)
  grid = Grid.new input
  ray_tracer = TemporaryRayTracer.new grid, best_asteroid
  ray_tracer.vaporize_asteroids
end

p solve_part_two input
