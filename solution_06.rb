require 'pry'

class ChronalCoordinates

  attr_reader :coordinates

  def initialize(coordinates)

    @origins = make_origins(coordinates)
    @max_x = 0
    @max_y = 0
    determine_max_dimensions
    @grid = make_initial_grid
    @origins_drawn = false
  end

  def draw_origins
    abc = ('A'..'Z').to_a
    @origins.each.with_index do |origin, i|
      origin.id = abc[i]
      key = "#{origin.x}, #{origin.y}"
      @grid[key] = origin
    end

    @origins_drawn = true

    render
  end

  def fill_in_grid
    draw_origins if @origins_drawn == false

    # 1.times.with_index do |i|
    #   @origins.each do |coordinate|
    #     coordinate.last_expanded.each do
    #   end
    #
    # end

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
    @origins.each do |origin|
      @max_x = origin.x if @max_x < origin.x
      @max_y = origin.y if @max_y < origin.y
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

  def make_origins(coordinates)
    individual_coordinates = coordinates.split("\n")

    collection_of_coordinates = individual_coordinates.collect do |coordinate|
      x = coordinate.split.first.to_i
      y = coordinate.split.last.to_i
      Coordinate.new(x, y)
    end
  end

end

class Coordinate

  attr_accessor :id, :last_expanded
  attr_reader :x, :y

  def initialize(x, y, id = nil)
    @last_expanded =
    @id = id
    @x = x
    @y = y
  end

end
