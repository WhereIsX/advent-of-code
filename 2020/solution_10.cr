require "./input_10.cr"

example = "
0
16
10
15
5
1
11
7
19
6
12
4
"

example2 = "
0
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
"

def parse(puzzle)
  puzzle.split("\n", remove_empty: true).map(&.to_i)
end 

def solve_part_1(puzzle)
  adapters = parse(puzzle)

  diff_1 = 0
  diff_2 = 0 
  diff_3 = 1 
  
  adapters.sort.each_cons_pair do |adapter1, adapter2|
    case adapter2 - adapter1
    when 1 
      diff_1 += 1
    when 2 
      diff_2 += 1
    when 3
      diff_3 += 1
    end 
  end
  return [diff_1, diff_2, diff_3]
end



def solve_part_2(puzzle)
  adapters = parse(puzzle).sort

  adapters_hash = Hash(Int32, Array(Int32)).new

  one_plug = -1 
  adapters.each_cons(4) do |adapter_series|
    first_adapter = adapter_series.first

    pluggables = adapter_series.select {|adapter| (1..3).includes?(adapter - first_adapter) } 

    if pluggables.size == 1 && one_plug < 0
      one_plug = first_adapter 
 
    elsif pluggables.size > 1 && one_plug >= 0 
      adapters_hash[one_plug] = pluggables 
      one_plug = -1 

    elsif pluggables.size > 1 && one_plug < 0 
      adapters_hash[first_adapter] = pluggables
    end 
  end 

  return adapters_hash




end 

p! solve_part_1(INPUT)