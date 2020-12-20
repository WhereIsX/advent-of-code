require "./input_19.cr"

ex1 = "
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: a
5: bb

ababbb
bababa
abbbab
aaabbb
aaaabbb
"

# valid_message =
# track path 
# look at leaf 
# go to the rules#leaf => 
# repeated go to rules#leaf until we find string
#   
#   we return to the last level (see path)
#


ex1_all_matches = "aaaabb, aaabab, abbabb, abbbab, aabaab, aabbbb, abaaab, ababbb"



# NOTE IF YOU ARE COPY PASTA-ING THE FOLLOWING CODE FOR YOUR AOC:
# => you need to remove the double-quotes `"` characters from your INPUT 
# => before you can use this code.  the parser expects the INPUT
# => to have NO QUOTE CHARACTERS!!
def parse(puzzle)
  # returns 
  # { 0 => [[4, 1, 5]], 
  #   1 => [[2, 3], [3, 2]], 
  #   2 => [[4, 4], [5, 5]],
  #   ...
  #   4 => [['a']], 
  #   5 => [['b']],
  # }
  rules, messages = puzzle.split("\n\n")
  [parse_rules(rules), parse_messages(messages)] 
end 

def parse_messages(messages)
  messages.split("\n", remove_empty: true)
end 

def parse_rules(rules)
  rules.split("\n", remove_empty:true).map do |line|

    rule, constituents = line.split(": ") # => ["0", "4 1 5"] OR ["1", "2 3 | 3 2"]
    
    constituents = constituents.split(" | ").map do |branch|
      # branch => "2 3" || "4 1 5" || "a" 
      if branch[0] == 'a' || branch[0] == 'b' 
        [branch[0]]
      else
        leaves = branch.chars.delete(" ")
        branch.split(" ").map(&.to_i)
      end 
    end 
    [rule.to_i, constituents] # => [ 0, [[4, 1, 5]] ]
  end.to_h
end 
p! parse(ex1)
