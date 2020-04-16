require_relative '../solutions/solution_06.rb' 

include AOC2019D06

example_input = <<~EXAMPLE
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
EXAMPLE

expected_total_orbits = 42 


puts "Given the example_input input: #{example_input}"
puts "we can prase it: #{solve(example_input)}"

#puts "total number of direct and indirect orbits should be 42: 
#{expected_total_orbits == solve(example_input)}"


