require 'pry-nav'
require 'set'
require_relative 'input_07'

Node = Struct.new(:id, :children, :parents, keyword_init: true)

class SumOfItsParts
  attr_reader :roots
  def initialize(string)
    directions =  parse(string)
    @nodes = directions.flatten.uniq.collect { |id|
      Node.new(id: id, children: [], parents: [])
    }
    @roots = connect(directions)
  end

  def has_node?(id)
    @nodes.collect {|n| n.id}.include?(id)
  end

  def children_node_ids(id)
    @nodes
    .find{|node| node.id == id}
    .children
    .collect{ |child| child.id}
  end

  def order
    path = []
    contestants = Set.new(@roots)

    until path.size == @nodes.size
      next_contestant = contestants.sort_by{|c| c.id}.first

      path.push(next_contestant.id)
      contestants.delete(next_contestant)
      next_contestant.children.each do |child|
        contestants.add(child) if all_parents_in_path?(child, path)
      end
    end
    path.join('')
  end

  private

  def parse(string)
    string.split("\n").collect do |line|
      words = line.split(' ')
      [words[1], words[-3]]
    end
  end

  def connect(directions)
    directions.each do |pair|
      parent_id = pair.first
      child_id = pair.last

      parent_node = @nodes.find { |node| node.id == parent_id}
      child_node = @nodes.find { |node| node.id == child_id}

      parent_node.children.push child_node
      child_node.parents.push parent_node
    end

    roots = @nodes.select {|n| n.parents.size == 0}
    if roots.size != 1
      puts "WARNING: \n\n multiple roots are present \n\n\n"
    end

    return roots
  end

  def all_parents_in_path?(child, path)
    parents_set = child.parents.collect{|p| p.id}.to_set
    path_set = path.to_set
    parents_set.subset?(path_set)
  end

end

# binding.pry
puts SumOfItsParts.new($aoc_input).order
