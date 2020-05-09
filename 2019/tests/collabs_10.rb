require_relative '../solutions/collabs_10.rb'
require 'rspec'

ex1 = <<~EX
  .#..#
  .....
  #####
  ....#
  ...##
  EX

describe 'parsing' do
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
end

describe 'find_asteroids' do
  it 'returns empty sets of asteroids' do
    grid = {}
    asteroids = find_asteroids(grid)
    expect(asteroids).to eq [].to_set
  end

  it 'returns the correct set of asteroids' do
    grid = {
      Point.new(0, 0) => false,
      Point.new(1, 0) => true,
      Point.new(0, 1) => false,
      Point.new(1, 1) => true,
    }
    asteroids = find_asteroids(grid)
    expect(asteroids === Point.new(0, 0)).to eq false
    expect(asteroids === Point.new(1, 0)).to eq true
    expect(asteroids === Point.new(0, 1)).to eq false
    expect(asteroids === Point.new(1, 1)).to eq true
  end
end

describe 'find_all_visible' do
  it 'works for a clear line of sight' do
    start_point = Point.new(0, 0)
    all_asteroids = [Point.new(0, 0), Point.new(1, 1)].to_set
    visible = find_all_visible start_point, all_asteroids
    expect(visible).to eq [Point.new(1, 1)].to_set
  end

  it 'blocks lines of sights' do
    start_point = Point.new(0, 0)
    all_asteroids = [Point.new(0, 0), Point.new(1, 1), Point.new(2, 2)].to_set
    visible = find_all_visible start_point, all_asteroids
    expect(visible).to eq [Point.new(1, 1)].to_set
  end

  it 'blocks weird lines of sights' do
    start_point = Point.new(0, 0)
    all_asteroids = [Point.new(0, 0), Point.new(1, 3), Point.new(2, 6)].to_set
    visible = find_all_visible start_point, all_asteroids
    expect(visible).to eq [Point.new(1, 3)].to_set
  end
end

describe 'entire thing' do
  it 'should return the best asteroid and its visible asteroids' do
   p  solve_part_one(INPUT * 10)
  end
end
