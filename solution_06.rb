require 'pry'

class ChronalCoordinates

  attr_reader :coordinates

  def initialize(coordinates)

    @coordinates = coordinates.split("\n").collect do |coordinate|
      "#{coordinate.split.first.to_i}, #{coordinate.split.last.to_i}"
    end
    @grid = make_initial_grid
    @drawn_coordinates = false
  end

  def draw_coordinates
    abc = ('A'..'Z').to_a
    @coordinates.each.with_index do |coordinate, i|
      @grid[coordinate] = abc[i]
    end

    @drawn_coordinates = true

    render
  end

  def fill_in_grid
    draw_coordinates if @drawn_coordinates == false

    


  end

  private

  def render
    max_x = max_dimension.first
    max_y = max_dimension.last
    rows = []

    (max_y + 1).times do |y|
      rows << (max_x + 2).times.collect{ |x| @grid["#{x}, #{y}"] }.join('')
    end

    image = rows.collect { |row| row + "\n" }.join
    puts image
    return image
  end

  def max_dimension
    across = 0
    down = 0

    @coordinates.each do |coordinate|
      xy = coordinate.split(',')
      x = xy.first.to_i
      y = xy.last.to_i

      across = x if across < x
      down = y if down < y
    end
    return [across, down]
  end

  def make_initial_grid
    max_x = max_dimension.first
    max_y = max_dimension.last

    grid = {}

    (max_y + 1).times do |y|
      (max_x + 2).times do |x|
        grid["#{x}, #{y}"] = '.'
      end
    end
    grid
  end



end
