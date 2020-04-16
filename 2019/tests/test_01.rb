require 'rspec'
require_relative '../solutions/solution_01.rb'

include AOC2019D01

describe 'fuel_required' do

  it 'should calculate fuel requirements for 12 mass' do
    expect(fuel_required 12).to eq 2
  end

  it 'should calculate fuel requirements 1969' do
    expect(fuel_required 1969).to eq 654
  end

  it 'should calculate fuel requirements 1969' do
    expect(fuel_required 100756).to eq 33583
  end

end

describe 'parse_input' do
  let(:input) {"88623\n101095\n149899"}
  it 'convert string to array of integers' do
    parse_input(input).collect do |mass_int|
      expect(mass_int).to be_a(Integer)
    end
  end
end

describe 'solve_part_one' do
  let(:input) {"88623\n101095\n149899"}
  it 'calculates the total fuel requirement' do
    expect(solve_part_one(input)).to eq 113199
  end
end

describe 'recursive_fuel_required' do

  it 'calculates the ACTUAL fuel required, including fuel for fuel, etc.' do
    expect(recursive_fuel_required(1969)).to eq 966
  end

  it 'calculates the ACTUAL fuel required, including fuel for fuel, etc.' do
    expect(recursive_fuel_required(14)).to eq 2
  end
end
