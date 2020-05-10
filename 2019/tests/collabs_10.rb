require_relative '../solutions/collabs_10.rb'
require 'rspec'

ex1 = <<~EX
  .#..#
  .....
  #####
  ....#
  ...##
  EX

describe 'Grid' do
  it 'parses correctly' do
    grid = Grid.new(ex1)

    expect(grid[Point.new(0, 0)]).to eq false
    expect(grid[Point.new(1, 0)]).to eq true
    expect(grid[Point.new(2, 0)]).to eq false
    expect(grid[Point.new(3, 0)]).to eq false
    expect(grid[Point.new(4, 0)]).to eq true

    expect(grid[Point.new(0, 1)]).to eq false
    expect(grid[Point.new(1, 1)]).to eq false
    expect(grid[Point.new(2, 1)]).to eq false
    expect(grid[Point.new(3, 1)]).to eq false
    expect(grid[Point.new(4, 1)]).to eq false

    expect(grid[Point.new(0, 2)]).to eq true
    expect(grid[Point.new(1, 2)]).to eq true
    expect(grid[Point.new(2, 2)]).to eq true
    expect(grid[Point.new(3, 2)]).to eq true
    expect(grid[Point.new(4, 2)]).to eq true

    expect(grid[Point.new(0, 3)]).to eq false
    expect(grid[Point.new(1, 3)]).to eq false
    expect(grid[Point.new(2, 3)]).to eq false
    expect(grid[Point.new(3, 3)]).to eq false
    expect(grid[Point.new(4, 3)]).to eq true

    expect(grid[Point.new(0, 4)]).to eq false
    expect(grid[Point.new(1, 4)]).to eq false
    expect(grid[Point.new(2, 4)]).to eq false
    expect(grid[Point.new(3, 4)]).to eq true
    expect(grid[Point.new(4, 4)]).to eq true
  end

  describe 'asteroids' do
    it 'returns empty sets of asteroids' do
      grid = Grid.new ""
      asteroids = grid.asteroids
      expect(asteroids).to eq [].to_set
    end

    it 'returns the correct set of asteroids' do
      grid = Grid.new <<~ASTEROIDS
      .#
      .#
      ASTEROIDS
      asteroids = grid.asteroids
      expect(asteroids === Point.new(0, 0)).to eq false
      expect(asteroids === Point.new(1, 0)).to eq true
      expect(asteroids === Point.new(0, 1)).to eq false
      expect(asteroids === Point.new(1, 1)).to eq true
    end
  end
end

describe 'RayTracer' do
  describe 'find_all_visible' do
    it 'works for a clear line of sight' do
      grid = Grid.new <<~GAL
      #.
      .#
      GAL
      ray_tracer = RayTracer.new grid
      start_point = Point.new(0, 0)
      visible = ray_tracer.find_all_visible_from start_point
      expect(visible).to eq [Point.new(1, 1)].to_set
    end

    it 'blocks lines of sights' do
      grid = Grid.new <<~GAL2
      #..
      .#.
      ..#
      GAL2
      ray_tracer = RayTracer.new grid
      start_point = Point.new(0, 0)
      visible = ray_tracer.find_all_visible_from start_point
      expect(visible).to eq [Point.new(1, 1)].to_set
    end

    it 'blocks weird lines of sights' do
      grid = Grid.new <<~GAL3
      #......
      ...#...
      ......#
      GAL3
      ray_tracer = RayTracer.new grid
      start_point = Point.new(0, 0)
      visible = ray_tracer.find_all_visible_from start_point
      expect(visible).to eq [Point.new(3, 1)].to_set
    end
  end
end

describe 'entire thing' do
  it 'should return the best asteroid and its visible asteroids' do
    input = (INPUT * 10).split("\n").shuffle.join("\n")
    best_asteroid, visible = *(solve_part_one input)
    puts
    puts "The best asteroid #{best_asteroid} can see #{visible} other asteroids!"
  end
end
