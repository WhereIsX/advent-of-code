require_relative '../solution_06.rb'
require 'rspec'

describe ChronalCoordinates do

  let(:sample_coordinates) {ChronalCoordinates.new('1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9')}

  # it 'stores the coordinates as hash keys in x-y- format' do
  #   expect(thing).to eq(other_thing)
  # end

  it 'draws the coordinates on the grid' do
    drawn_coordinates = <<~GRID
      ..........
      .A........
      ..........
      ........C.
      ...D......
      .....E....
      .B........
      ..........
      ..........
      ........F.
      GRID

    expect(sample_coordinates.draw_coordinates).to eq(drawn_coordinates)
  end

  it 'fills in the grid' do
    filled_in_grid = <<~GRID
      aaaaa.cccc
      aAaaa.cccc
      aaaddecccc
      aadddeccCc
      ..dDdeeccc
      bb.deEeecc
      bBb.eeee..
      bbb.eeefff
      bbb.eeffff
      bbb.ffffFf
    GRID

    expect(sample_coordinates.fill_in_grid).to eq(filled_in_grid)
  end

  it 'determines that D has an area of 9' do
    expect(sample_coordinates.area('D').to eq(9))
  end

  it 'determines that E has an area of 17' do
    expect(sample_coordinates.area('E').to eq(17))
  end

  it 'determines that A has "infinite" area' do
    expect(sample_coordinates.area('A').to eq('infinite'))
  end

  it 'understands that A, B, C and F have "infinite" area' do
    expect(sample_coordinates.coordinates_with_infinite).to eq(['A', 'B', 'C', 'F'])
  end

  it 'determines the largest finite area is 17' do
    expect(sample_coordinates.largest_finite_area).to eq(17)
  end
end
