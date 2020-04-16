require 'rspec'
require_relative '../solutions/solution_08.rb'

include AOC2019D08


describe AOC2019D08::Layer do  
	let(:example) { '123456789012' }

	let(:example_layer) {
		described_class.new(
			width: 3,
			height: 2,
			pixels: [1,2,3,4,5,6],
		)
	}

	describe '#get_pixel' do 

		it 'know the 0,0 pixel' do 
			expect(example_layer.get_pixel(0, 0)).to eq 1 
		end 

		it 'know the 1,1 pixel' do 
			expect(example_layer.get_pixel(1, 1)).to eq 5 
		end 

		it 'error on out of bounds' do 
			expect{example_layer.get_pixel(5, 5)}.to raise_error IndexError 
		end 

	end

	describe '#render' do 
		it 'gives us a pitcher' do 
			expect(example_layer.render).to eq "123\n456"
		end
	end

end  

describe AOC2019D08::Image do 
	let(:example_image) {
		Image.new(
			layers: [
				Layer.new(
					width: 3,
					height: 2,
					pixels: [1,2,3,4,5,6],
				),
				Layer.new(
					width: 3,
					height: 2,
					pixels: [7,8,9,0,1,2],
				),
			],
		)
	}

	describe '#import_from_string' do 
		it 'constructs correctly from a string' do 
			constructed_image = described_class.new()
			constructed_image.import_from_string(
				string: '123456789012',
				width: 3, 
				height: 2,
			)
			expect(constructed_image).to eq example_image 
		end 
	end

	describe '#layer_with_fewest_pixel' do
		it 'knows which layer has the fewest 0s' do
			expect(example_image.layer_with_fewest_pixel(0)).to eq example_image.layers.first
		end
		it 'knows which layer has the fewest 6s' do
			expect(example_image.layer_with_fewest_pixel(6)).to eq example_image.layers.last
		end
	end

	let(:example_img_with_transparency) { 
		Image.new(
			layers: [
				Layer.new(
					width: 2, 
					height: 2, 
					pixels: [0,2,2,2],
				),
				Layer.new(
					width: 2, 
					height: 2, 
					pixels: [1,1,2,2],
				),
				Layer.new(
					width: 2, 
					height: 2, 
					pixels: [2,2,1,2],
				),
				Layer.new(
					width: 2, 
					height: 2, 
					pixels: [0,0,0,0],
				),
			]
		)
	}

	describe '#get_pixel' do 
		it 'knows the top left final pixel' do 	
			expect(example_img_with_transparency.get_pixel(0, 0)).to eq 0 
		end
		it 'knows the bottom left final pixel' do 	
			expect(example_img_with_transparency.get_pixel(0, 1)).to eq 1 
		end
	end 

	describe '#export' do 
		it 'export the final image as a layer' do 
			expect(example_img_with_transparency.export).to eq Layer.new(
				width: 2,
				height: 2,
				pixels: [0,1,1,0],
			)
		end 	
	end
end 
