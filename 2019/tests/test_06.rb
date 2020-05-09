require 'pry'
require 'rspec'
require_relative '../solutions/solution_06.rb'

include AOC2019D06

describe "make_planets" do
  let(:example) {<<~PLANETS
    COM)B
  B)C
  C)D
  D)E
  E)F
  B)G
  G)H
  D)I
  E)J
  J)K
  K)L
PLANETS
}

  it "makes planets from the string input" do
    expect(make_planets(example)).to include Planet.new(id: "B", orbits_around: "COM")
  end
end
