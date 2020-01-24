# require 'rspec'
require_relative '../solution_09.rb'
include MarblesMania
#
# describe MarblesMania do
#   it 'starts a new game' do
#     expect(MarblesMania.new()).to eq([])
#   end
# end

inputs = [
  [9, 25],
  [10, 1618],
  [13, 7999],
  [17, 1104],
  [21, 6111],
  [30, 5807],
  [405, 70953]
]

# inputs.each do |pair|
#   MarblesMania.run_simulation(*pair)
#   sleep(10)
# end

MarblesMania.run_simulation(*inputs[1])
