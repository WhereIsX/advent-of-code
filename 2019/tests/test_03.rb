require 'rspec'
require_relative '../solutions/solution_03.rb'

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

describe '#make_segments' do
  let(:wire1) {"R8,U5,L5,D3"}

  it {
    wire1_seg1 = Segment.new(Point.new(1,0), Point.new(8, 0))
    wire1_seg4 = Segment.new(Point.new(3, 4), Point.new(3,2))
    expect(make_segments(wire1).first).to eq wire1_seg1
    expect(make_segments(wire1).last).to eq wire1_seg4
  }
end


describe '#solve' do
  let(:example1) { <<~EX
    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83
    EX
  }
  let(:example1_solution) { 159 }

  it {
    expect(solve(example1)).to eq example1_solution
  }


  let(:example2) { <<~EX
    R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
    U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
    EX
  }
  let(:example2_solution) { 135 }

  it {
    expect(solve(example2)).to eq example2_solution
  }
end
