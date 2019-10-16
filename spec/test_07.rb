require_relative '../solution_07.rb'
require 'rspec'

describe Forest do

  let(:example_input) {
    Forest.new.parse(<<~INPUT
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
    INPUT
   )
  }

  it "expects C must be finished before step A" do
    expect(example_input.has_directed_edge?("C", "A")).to eq(true)
  end
  it "expects C must be finished before step F" do
    expect(example_input.has_directed_edge?("C", "F")).to eq(true)
  end

  it "expects A must be finished before step B" do
    expect(example_input.has_directed_edge?("A", "B")).to eq(true)
  end

  it "expects A must be finished before step D" do
    expect(example_input.has_directed_edge?("A", "D")).to eq(true)
  end

  it "expects B must be finished before step E" do
    expect(example_input.has_directed_edge?("B", "E")).to eq(true)
  end

  it "expects D must be finished before step E" do
    expect(example_input.has_directed_edge?("D", "E")).to eq(true)
  end

  it "expects F must be finished before step E" do
    expect(example_input.has_directed_edge?("F", "E")).to eq(true)
  end

  # it "expects "



end
