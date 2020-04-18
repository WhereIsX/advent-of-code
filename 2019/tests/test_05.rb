require 'rspec'
require_relative '../solutions/solution_05.rb'

include AOC2019D05

describe AOC2019D05 do
  let(:example1str) {"1002,4,3,4,33"}
  let(:example1arr) {[1002,4,3,4,33]}
  it 'parses into a Hamster::Vector' do
    expect(parse(example1str)).to eq Hamster::Vector[1002,4,3,4,33]
  end

  it 'can #get_parameters' do
    expect(get_parameters(
      intcode: example1arr,
      opcode: 2,
      section_pos: 0,
      param_mode: [0,1]
      )). to eq [33, 3, 33]
  end



end
