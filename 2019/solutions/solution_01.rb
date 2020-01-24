require 'pry'


module AOC2019D01
  def fuel_required(mass)
    (mass / 3).floor - 2
  end


  def solve_part_one(input_long_string)
    masses = parse_input(input_long_string)
    masses.collect do |mass|
      fuel_required(mass)
    end.reduce(:+)
  end

  def parse_input(input_long_string)
    input_long_string
      .split("\n")
      .collect(&:to_i)
  end

  def recursive_fuel_required(mass)
    fuel = fuel_required(mass)
    if fuel <= 0
      0
    else
      fuel + recursive_fuel_required(fuel)
    end
  end

  def solve_part_two(input_long_string)
    masses = parse_input(input_long_string)
    masses.collect do |mass|
      recursive_fuel_required(mass)
    end.reduce(:+)
  end

end

include AOC2019D01
input = "88623
101095
149899
89383
54755
73496
115697
99839
65903
140201
95734
144728
113534
82199
98256
107126
54686
61243
54763
119048
58863
134097
84959
130490
145813
115794
130398
69864
133973
58382
75635
77153
132645
91661
126536
118977
137568
100341
142080
63342
84557
51961
61956
87922
92488
107572
51373
70148
80672
134880
105721
100138
80394
145117
50567
122606
112408
110737
111521
144309
65761
113147
58920
96623
65479
66576
94244
64493
142334
65969
99461
143656
134661
90115
122994
66994
135658
134336
102958
111410
107930
54711
101397
111350
86453
134383
134276
130342
80522
64875
68182
83400
121302
105996
123580
130373
123987
107932
78930
132068"

puts solve_part_two(input)
