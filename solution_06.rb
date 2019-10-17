require 'pry'

class ChronalCoordinates

  def initialize(coordinates)
    @coordinates = make_origin_coordinates(coordinates)
    # long running list of coordinates that are "true" and to be #rendered
    @coord_of_latest_cycle = make_origin_coordinates(coordinates)
    # list that points to a small subset of @coordinates,
    # @coordinates that were "grown" in the last cycle
    @max_x = 0
    @max_y = 0
    determine_max_dimensions
    @grid = make_initial_grid
    @drawn_origins = false
  end

  def draw_origins
    draw_coordinates_onto_grid
    @drawn_origins = true
    render
  end

  def draw_coordinates_onto_grid
    @coordinates.each do |coordinate|
      key = "#{coordinate.x}, #{coordinate.y}"
      @grid[key] = coordinate
    end
  end

  def fill_in_grid
    draw_origins if @drawn_origins == false

    6.times do |cycle|
      all_possible_coordinates = @coord_of_latest_cycle.collect { |c| c.make_neighbors }.flatten
      coordinates_by_location = organize_coordinates_by_location(all_possible_coordinates)
      contested_locations = list_contested_locations(coordinates_by_location)
      # if two Coordinates want to grow in the same location,
      # and they are from two different colonies, the location is to be unoccupied
      # example:
      # a and b both want to occupy same coordinate in this growth phase
      # the coordinate is to remain a '.'

      # remove contested locations from coordinates_by_location
      contested_locations.each do |loc|
        coordinates_by_location.delete(loc)
      end

      # collect unique coordinates
      unique_coordinates = coordinates_by_location.collect do |loc, coord|
        coord.first
      end

      # make contested_locations into coordinates with '.' as # ID
      list_real_contests = contested_locations.uniq.select do |loc|
        @grid[loc] == '.'
      end
      .collect do |loc|
        x = loc.split(',').first.to_i
        y = loc.split(',').last.to_i
        Coordinate.new(x, y, id: '.', cycle: cycle)
      end

      @coordinates += list_real_contests

      good_coordinates = unique_coordinates.select do |coord|
        within_range_of_map?(coord.x, coord.y) &&
        location_is_empty?(coord.x, coord.y) &&
        neighbors_are_valid?(coord)
        # binding.pry
      end
      @coordinates += good_coordinates.dup
      @coord_of_latest_cycle = good_coordinates

      # binding.pry

      draw_coordinates_onto_grid
      render
      sleep(3)
    end
  end

  private

  def render
    rows = []

    (@max_y + 1).times do |y|
      rows << (@max_x + 1).times.collect{ |x|
        str_or_coord = @grid["#{x}, #{y}"]
        str_or_coord.class == String ? str_or_coord : str_or_coord.id
      }.join('')
    end

    image = rows.collect { |row| row + "\n" }.join
    system('clear')
    puts "012345678"
    puts image
    return image
  end

  def determine_max_dimensions
    @origins.each do |origin|
      @max_x = origin.x if @max_x < origin.x
      @max_y = origin.y if @max_y < origin.y
    end
  end

  def make_initial_grid
    grid = {}

    (@max_y + 1).times do |y|
      (@max_x + 1).times do |x|
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

  def organize_coordinates_by_location(all_possible_coordinates)
    coordinates_by_location = {}
    all_possible_coordinates.each do |coord|
      location = "#{coord.x}, #{coord.y}"
      if coordinates_by_location[location] == nil
        coordinates_by_location[location] = [coord]
      else
        coordinates_by_location[location] += [coord]
      end
    end
    coordinates_by_location
  end

  def list_contested_locations(coordinates_by_location)
    # find locations that are 'contested' by more than 1 colony
    contested_locations = []
    coordinates_by_location.each_value do |coords|
      first_coord_id = coords.first.id
      coords.each do |coord|
          if coord.id != first_coord_id
            contested_locations << "#{coord.x}, #{coord.y}"
          end
      end
    end
    contested_locations
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
