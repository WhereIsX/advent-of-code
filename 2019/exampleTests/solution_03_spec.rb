require 'rspec'
require_relative 'solution_03.rb'

include AOC2019D03

describe AOC2019D03::Segment do
  let(:horiz) { Segment.new(Point.new(0, 0), Point.new(10, 0)) }
  let(:vert) { Segment.new(Point.new(8, 5), Point.new(8, -5)) }

	describe '#intersections_with' do
		subject { described_class.new(Point.new(0, 0), Point.new(10, 0)) }

		it 'returns [] when given point does not intersect' do
      segment = Segment.new(Point.new(10, 10), Point.new(10, 20))
      expect(subject.intersections_with(segment)).to eq []
		end

		it 'returns intersection points of segments' do
      segment = Segment.new(Point.new(8, 5), Point.new(8, -5))
      expect(subject.intersections_with(segment)).to eq [Point.new(8, 0)]
		end

    it 'returns intersections for horiz overlapping segments' do
      segment = Segment.new(Point.new(8, 0), Point.new(18, 0))
      expect(subject.intersections_with(segment)).to eq [
        Point.new(8, 0), Point.new(9, 0), Point.new(10, 0)]
    end
	end

  describe '#horiz?' do
    it { expect(horiz.horiz?).to eq true }
    it { expect(vert.horiz?).to eq false }
  end

  describe '#vert?' do
    it { expect(horiz.vert?).to eq false }
    it { expect(vert.vert?).to eq true }
  end

	describe '#x_range' do
		it { expect(horiz.x_range).to eq (0..10) }
		it { expect(vert.x_range).to eq (8..8) }
	end

	describe '#y_range' do
		it { expect(vert.y_range).to eq (-5..5) }
		it { expect(horiz.y_range).to eq (0..0) }
	end

  describe '#x_pos' do
  	it { expect(vert.x_pos).to eq 8 }
    it { expect { horiz.x_pos }.to raise_error StandardError }
	end

	describe '#y_pos' do
		it { expect(horiz.y_pos).to eq 0 }
		it { expect { vert.y_pos }.to raise_error StandardError }
	end
end
