require 'pry'

class ChronalCoordinates

  attr_reader :coordinates

  def initialize(coordinates)

    @coordinates = make_coordinates(coordinates)
    @max_x = 0
    @max_y = 0
    determine_max_dimensions
    @grid = make_initial_grid
    @drawn_coordinates = false
  end

  def draw_coordinates
    abc = ('A'..'Z').to_a
    @coordinates.each.with_index do |coordinate, i|
      coordinate.id = abc[i]
      key = "#{coordinate.x}, #{coordinate.y}"
      @grid[key] = coordinate
    end

    @drawn_coordinates = true

    render
  end

  def fill_in_grid
    draw_coordinates if @drawn_coordinates == false




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

  def make_coordinates(coordinates)
    individual_coordinates = coordinates.split("\n")

    collection_of_coordinates = individual_coordinates.collect do |coordinate|
      x = coordinate.split.first.to_i
      y = coordinate.split.last.to_i
      Coordinate.new(x, y)
    end
  end

end

class Coordinate

  attr_accessor :x, :y, :id

  def initialize(x, y, id = nil)
    @id = id
    @x = x
    @y = y
  end

end
