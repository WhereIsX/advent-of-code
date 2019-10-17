require 'rspec'
require_relative '../solution_07.rb'

describe SumOfItsParts do

  nodes = <<~NODES
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.")
  NODES

  let(:example_tree) { SumOfItsParts.new(nodes)}

  it 'has a node C' do
    expect(example_tree.has_node?(id = 'C')).to eq(true)
  end

  it 'has a node B' do
    expect(example_tree.has_node?(id = 'B')).to eq(true)
  end

  it 'has a node A which has B and D as its children' do
    expect(example_tree.children_node_ids('A')).to eq(['B', 'D'])
  end

  # it 'knows root node includes C' do
  #   expect(example_tree.roots.id).to eq('C')
  # end

  # it 'finds that both A and F are available after C' do
  #   expect(example_tree.root.children_node_ids(C)).to eq(['A', 'F'])
  # end

  # it 'chooses A over F' do
  #   expect(example_tree.)
  # end

  it 'determines the order: CABDFE' do
    expect(example_tree.order).to eq('CABDFE')
  end

  it 'takes 15 seconds to complete the example given 2 hands' do
    expect(example_tree.time_required(2)).to eq(15)
  end

end
