# require 'pry-nav'
#
#   class Forest
#
#
#     def initialize
#       @nodes = {}
#     end
#
#     def parse(string)
#       lines = string.split("\n")
#
#       directed_input = lines.collect do |line|
#         words = line.split(' ')
#         [words[1], words[-3]]
#       end
#
#       directed_input.each do |input|
#         id = input.first
#         child = input.last
#
#         if @nodes[id].nil?
#           @nodes[id] = Node.new(id, Node.new(child))
#         else
#           # binding.pry
#           @nodes[id].children.push(Node.new(child))
#         end
#       end
#
#       binding.pry
#
#       self
#     end
#
#     def has_directed_edge?(source_id, destination_id)
#       @nodes[source_id].has_child?(destination_id)
#     end
#
#     def walk_alphabetically
#
#
#
#       # queue = {}
#       # result = {}
#       # start = next(@nodes)
#       # result.append(start)
#       # queue.add(@nodes.exept(start))
#       # queue.add(start.children)
#       # while queue.is_empty()
#       # result.append(queue.next())
#       # queue.append()
#     end
#
#   end
#
# class Node
#   attr_reader :id
#   attr_accessor :children
#   def initialize(id, child = nil)
#     @id = id
#     if child.nil?
#       @children = []
#     else
#       @children = [child]
#     end
#   end
#
#   def has_child?(id)
#     @children.collect {|c| c.id}.include?(id)
#   end
# end
