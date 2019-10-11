require 'pry'

class ChronalCoordinates

  def initialize(coordinates)
    @coordinates = make_origin_coordinates(coordinates)
    @coord_of_latest_cycle = make_origin_coordinates(coordinates)
    @max_x = 0
    @max_y = 0
    determine_max_dimensions
    @grid = make_initial_grid
    @drawn_origins = false
  end

  def draw_origins
    draw_coordinates
    @drawn_origins = true
    render
  end

  def draw_coordinates
    @coordinates.each do |coordinate|
      key = "#{coordinate.x}, #{coordinate.y}"
      @grid[key] = coordinate
    end
  end

  def fill_in_grid
    draw_origins if @drawn_origins == false

    2.times.with_index do |cycle|
      possible_coordinates = @coord_of_latest_cycle.collect { |c| c.make_neighbors }.flatten
      good_coordinates = possible_coordinates.select do |coord|
        within_range_of_map?(coord.x, coord.y) &&
        location_is_empty?(coord.x, coord.y) &&
        neighbors_are_valid?(coord)
      end
      @coordinates += good_coordinates
      @coord_of_latest_cycle = good_coordinates
      draw_coordinates
    end
    render
  end

  private

  def render
    rows = []

    (@max_y + 1).times do |y|
      rows << (@max_x + 2).times.collect{ |x|
        str_or_coord = @grid["#{x}, #{y}"]
        str_or_coord.class == String ? str_or_coord : str_or_coord.id
      }.join('')
    end

    image = rows.collect { |row| row + "\n" }.join
    puts "\n\n\n"
    puts image
    return image
  end

  def determine_max_dimensions
    @coordinates.each do |coordinate|
      @max_x = coordinate.x if @max_x < coordinate.x
      @max_y = coordinate.y if @max_y < coordinate.y
    end
  end

  def make_initial_grid
    grid = {}

    (@max_y + 1).times do |y|
      (@max_x + 2).times do |x|
        grid["#{x}, #{y}"] = '.'
      end
    end
    grid
  end

  def make_origin_coordinates(coordinates)
    individual_coordinates = coordinates.split("\n")

    abc = ('A'..'Z').to_a
    collection_of_coordinates = individual_coordinates.collect.with_index do |coordinate, i|
      x = coordinate.split.first.to_i
      y = coordinate.split.last.to_i
      Coordinate.new(x, y, cycle: 0, id: abc[i])
    end
  end

  def within_range_of_map?(x, y)
    (x >= 0) && (x <= @max_x) && (y >= 0) && (y <= @max_y)
  end

  def location_is_empty?(x, y)
    @grid["#{x}, #{y}"] == '.'
  end

  def neighbors_are_valid?(coordinate)
    coordinate.neighbors_coordinates.each do |neighbor_coordinates|
      neighbor_key = "#{neighbor_coordinates.first}, #{neighbor_coordinates.last}"
      neighbor = @grid[neighbor_key]
      return false if !neighbor_valid?(neighbor, coordinate.id)
    end
    return true
  end

  def neighbor_valid?(neighbor, self_id)
    neighbor.nil? || neighbor == '.' || neighbor.id.downcase == self_id
  end

end

class Coordinate
  attr_reader :x, :y, :id, :cycle
  def initialize(x, y, id: nil, cycle:)
    @x = x
    @y = y
    @id = id
    @cycle = cycle
  end

  def neighbors_coordinates
    [up, down, left, right]
  end

  def make_neighbors
    [up, down, left, right].collect do |coord|
      Coordinate.new(*coord, id: @id.downcase, cycle: @cycle + 1)
    end
  end

  private

  def up
    [x, y+1]
  end

  def down
    [x, y-1]
  end

  def left
    [x-1, y]
  end

  def right
    [x+1, y]
  end
end
