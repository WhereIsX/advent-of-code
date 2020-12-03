def solve_part_1( input )
end

def solve_part_2( input )
end

require "spec"

RUN_TESTS_PART1 = false
describe "Part 1" do
  if RUN_TESTS_PART1
    describe "parse" do
      it "accurately parses the forest" do
        f = parse( example ) 
        f["x0y0"].should eq '.'
        f["x3y1"].should eq '.'
        f["x6y2"].should eq '#'
      end
    end

    describe "solution" do
      it "correctly reports the number of tree-collisions" do
        #puts solve_part_1(example)
        # 7
      end

      it "correctly reports the number of tree-collisions for the input" do
        #puts solve_part_1(INPUT)
        # 230
      end
    end
  end
end