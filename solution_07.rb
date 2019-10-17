require 'pry-nav'
require 'set'
require_relative 'input_07'

Node = Struct.new(:id, :children, :parents, :time, keyword_init: true)

Worker = Struct.new(:current_job, :idle, :time_left, keyword_init: true) {

  def take_first_job!(queue)
    first_job = queue.sort_by{|n| n.id}.first
    self.current_job = first_job
    self.idle = false
    self.time_left = first_job.time
    queue.delete(first_job)
  end

  def unassign_job
    self.current_job = nil
    self.idle = true
    self.time_left = nil
  end
}

class SumOfItsParts
  @@time = {}
  ('A'..'Z').each.with_index do |letter, seconds|
    @@time[letter] = seconds + 61
  end

  attr_reader :roots

  def initialize(string)
    directions =  parse(string)
    @nodes = make_nodes(directions)
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
    done = []
    queue = Set.new(@roots)
    until done.size == @nodes.size
      next_step = queue.sort_by{|n| n.id}.first

      done.push(next_step.id)
      queue.delete(next_step)
      next_step.children.each do |child|
        queue.add(child) if all_parents_done?(child, done)
      end

    end
    done.join('')
  end

  def time_required(number_workers)
    done = []
    queue = Set.new(@roots)
    workers = []
    number_workers.times {|n| workers << Worker.new(idle: true)}
    time_elapsed = 0

    until done.size == @nodes.size
      workers.each do |worker|
        if !worker.idle
          worker.time_left -= 1
          if worker.time_left == 0
            done.push(worker.current_job.id)
            worker.current_job.children.each do |child|
              queue.add(child) if all_parents_done?(child, done)
            end
            worker.unassign_job
          end
        end
      end
      workers.each do |worker|
        if !queue.empty? && worker.idle
          worker.take_first_job!(queue)
        end
      end
      puts "time: #{time_elapsed}"
      puts "workers: #{workers.collect{|w| w.dig(:current_job, :id)}}"
      time_elapsed += 1
    end
    return time_elapsed - 1
  end


  private

  def parse(string)
    string.split("\n").collect do |line|
      words = line.split(' ')
      [words[1], words[-3]]
    end
  end

  def make_nodes(directions)
    unique_nodes = directions.flatten.uniq

    unique_nodes.collect do |id|
      Node.new(id: id, time: @@time[id], children: [], parents: [])
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

  def all_parents_done?(child, done)
    parents_set = child.parents.collect{|p| p.id}.to_set
    done_set = done.to_set
    parents_set.subset?(done_set)
  end

end

aoc = SumOfItsParts.new($aoc_input)

puts "order:  " + aoc.order.to_s
puts "time:  " + aoc.time_required(5).to_s
