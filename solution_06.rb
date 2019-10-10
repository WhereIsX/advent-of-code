require 'pry'

class ChronalCoordinates

  attr_reader :coordinates

  def initialize(coordinates)
    @coordinates = coordinates.split("\n")
    @grid = self.make_initial_grid
    binding.pry
  end

  def draw_coordinates
    abc = ('A'..'Z').to_a
    @coordinates.each.with_index do |coordinate, i|
      @grid[coordinate] = abc[i]
    end

    @grid.collect {|k,v| v} 

    # self.render
  end

  def render
    max_x = self.max_dimension.first
    max_y = self.max_dimension.last
    rows = []

    (max_y + 1).times do |y|
      rows << (max_x + 1).times.collect{ |x| @grid["#{x-1}, #{y-1}"] }.join('')
    end

    rows.join("\n")
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
    max_x = self.max_dimension.first
    max_y = self.max_dimension.last

    grid = {}

    (max_y + 1).times do |y|
      (max_x + 1).times do |x|
        grid["x#{x - 1}, y#{y - 1}"] = '.'
      end
    end
    grid
  end

end
