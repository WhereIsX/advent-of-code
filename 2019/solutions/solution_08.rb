require 'pry'

module AOC2019D08
	Black = 0 
	White = 1 
	Transparent = 2 

	Image = Struct.new(:layers, keyword_init: true) {
		def import_from_string(string:, width:, height:)
			length = width * height
			self.layers = string.chars.each_slice(length).collect do |pixels|
				Layer.new(
					width: width,
					height: height,
					pixels: pixels.collect(&:to_i),
				)
			end
		end
		
		def layer_with_fewest_pixel(pixel) 
			layers
				.sort_by do |layer|
					layer.pixels.count(pixel)
				end
				.first
		end

		def get_pixel(x,y, transparent_value=Transparent)
			layers
				.find { |layer| layer.get_pixel(x,y) != transparent_value } 
				.get_pixel(x,y)
		end

		def export
			width = layers.first.width 
			height = layers.first.height
			
			final_pixels = [*(0...height)].product([*(0...width)])
				.collect do |coord| 
					y, x = *coord 
					get_pixel(x,y) 
				end

			Layer.new(
				width: width,
				height: height, 
				pixels: final_pixels, 
			)
		end
	}

	Layer = Struct.new(:width, :height, :pixels, keyword_init: true) {
		def get_pixel(x, y)
			# x left -> right 
			# y top -> bottom 
			pixels.fetch(y * width + x)				
		end 
		
		def render 
			# loop over all the rows to display
			height.times.collect do |y|
				# join the pixels into a single string
				pixels[y*width,width].join
			end.join("\n")
		end

	}


	# make image
		# image is made of up layers
			# layers are made of pixels 
		
	# apply search fn to layers (`.select`) 
	# count digits per layer 


	def solve_part_one(
			input:,
			width:, 
			height:,
			fewest:, 
			first_mult:,
			second_mult:
		)
		
		image = Image.new
		image.import_from_string(
			string: input, 
			width: width, 
			height: height,
		)

		layer = image.layer_with_fewest_pixel(fewest)
		first_mult_count = layer.pixels.count(first_mult)
		second_mult_count = layer.pixels.count(second_mult)

		first_mult_count * second_mult_count		
	end 

	def solve_and_render_part_two(
		input:,
		width:,
		height:
	)
		def replace_colors(string)
			palette  = {
				"0"=>"█",
				"1"=>" ",
				"2"=>"!",
			}
			string.each_char.collect do |char|
				palette.fetch(char, char)
			end.join
		end

		image = Image.new()
		image.import_from_string(string: input, width: width, height: height)
	
		output = replace_colors(image.export.render)
		puts output
	end

end
