require 'pry-nav'
require 'rspec'


module AOC2019D03

	Point = Struct.new(:x, :y)

	class Segment < Struct.new(:start_point, :end_point)

		def initialize(start_point, end_point)
			super(start_point, end_point)
		  raise ArgumentError, 'empty segment' if start_point == end_point
			raise ArgumentError, 'not vert or horiz line' if !horiz? && !vert?
		end

		def intersections_with(segment)
			if 		horiz?
						if segment.horiz? &&
							segment.y_pos == y_pos
							overlapping_range(segment.x_range, x_range) do |n|
								Point.new(n, y_pos)
							end
						elsif self.x_range.include?(segment.x_pos) 	&&
									segment.y_range.include?(self.y_pos)
										return [Point.new(segment.x_pos, y_pos)]
						else
										return []
						end

			elsif vert?
						if segment.vert? &&
							segment.x_pos == x_pos
							overlapping_range(segment.y_range, y_range) do |n|
								Point.new(x_pos, n)
							end
						elsif y_range.include?(segment.y_pos) 			&&
									segment.x_range.include?(self.x_pos)
										return [Point.new(x_pos, segment.y_pos)]
						else
										return []
						end

      end
		end

		def overlapping_range(r1, r2, &blk)
			# r1 0..10
			# r2 20..30
			#
			# r1 20..30
			# r2 0..10

			return [] if r1.max < r2.begin || r2.max < r1.begin
			([r1.begin, r2.begin].max..[r1.max, r2.max].min).map(&blk)

		end

		def horiz?
      start_point.y == end_point.y
		end

		def vert?
			start_point.x == end_point.x
		end

    def x_range
      if start_point.x <= end_point.x
				(start_point.x..end_point.x)
			else
				(end_point.x..start_point.x)
			end
		end

		def y_range
      if start_point.y <= end_point.y
				(start_point.y..end_point.y)
			else
				(end_point.y..start_point.y)
      end
		end

		def x_pos
			if vert?
				start_point.x
			else
				raise 'x_pos undefined for range'
			end
		end

		def y_pos
			if horiz?
				start_point.y
			else
				raise 'y_pos undefined for range'
			end
		end
	end



	def solve(input_as_string)

		# process input into nodes?

		# generate a hash where
		# { Point: string }
		# 	and Point is a Struct (x,y)!



	end

	def make_vertices(input_as_string, wire_name)

		instructions = input_as_string.split(',')

		vertices = []
		last_vertex = Point.new(0,0)

		instructions.each do |dir|
			x, y = *last_vertex	# multiple assignment using splat on a Struct
			direction = dir[0]	# = 'R' (right) | 'L' (left) | 'U' (up) | 'D' (down
			distance = dir[1].to_i

			case direction
				when 'R'
					new_point = Point.new(x + distance, y)
				when 'L'
					new_point = Point.new(x - distance, y)
				when 'U'
					new_point = Point.new(x, y - distance)
				when 'D'
					new_point = Point.new(x, y + distance)
			end

			vertices << new_point
		end
		vertices
	end
end
