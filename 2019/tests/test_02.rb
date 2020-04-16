require 'rspec'
require_relative '../solutions/solution_02.rb'

include AOC2019D02

describe 'it parses the input into an array' do
  let(:example1)  {[1,0,0,0,99]}
  let(:answer1)   {[2,0,0,0,99]}

  let(:example2)  {[2,3,0,3,99]}
  let(:answer2)   {[2,3,0,6,99]}

  let(:example3)  {[2,4,4,5,99,0]}
  let(:answer3)   {[2,4,4,5,99,9801]}

  let(:example4)  {'1,1,1,4,99,5,6,0,99'}
  let(:answer4)   {[30,1,1,4,2,5,6,0,99]}

  it 'correctly executes opcode 1' do
    execute_section(example1, 0)
    expect(example1).to eq answer1
  end

  it 'correctly exeutes opcode 2 part1' do
    execute_section(example2, 0)
    expect(example2).to eq answer2
  end

  it 'correctly executes opcode 2 part2' do
    execute_section(example3, 0)
    expect(example3).to eq answer3
  end

  it 'correctly executes a multi-sectioned intcode' do
    expect(solve_part_1(example4, 1, 1)).to eq answer4.first
  end

end
