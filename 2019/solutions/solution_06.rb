require 'pry-nav'
require 'set'

module AOC2019D06 

	Planet = Struct.new(
		:id,
		:orbits_around,
		keyword_init: true 
	)
	# currently, a Planet would know what it orbits around (parent), 
	# but it wouldn't know what orbits around it (children)

	def solve(puzzle_input)
		
		planets = Set.new()
		puzzle_input
			.split("\n")
			.each do |instruction|
				planets_involved = instruction.split(")") 
				parent_planet, child_planet = *planets_involved
				
				planets_involved.each do |potential_new_planet|
						
				end

			end 		
	end 
end 
