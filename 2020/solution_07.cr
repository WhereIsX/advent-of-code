require "./input_07.cr"

example = "
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"

class Bag 
  getter color
  property inner_bags, outer_bags

  def initialize(color : String, inner = Hash(Bag, UInt32).new, outer = Array(Bag).new)
    @color = color
    @inner_bags = inner
    @outer_bags = outer
  end 

  def inspect
    inner = @inner_bags.map {|bag, _| bag.color}
    outer = @outer_bags.map {|bag| bag.color}
    return "@color: #{@color} \n@inner_bags: #{inner} \n@outer_bags: #{outer} \n\n"
  end 
end 

# return a DAG from the strings
def parse(puzzle)
  bags = Hash(String, Bag).new
  # {"light red" => Bag.new("light red"), ... }


  puzzle.split("\n", remove_empty: true).each do |line|
    parent_color = line.split(" bags contain").first
    parent_bag = bags[parent_color]? || Bag.new(parent_color)
    bags[parent_color] = parent_bag


    children = line.scan(/(?<bag_count>\d+) (?<bag_color>\w+ \w+)\sbag/).map { |match| match.named_captures }
    # [{"bag_count" => "5", "bag_color" => "faded blue"}, 
    #  {"bag_count" => "6", "bag_color" => "dotted black"}]
    
    # find parent + children in bags hash 
    # if present, use them
    # else Bag.new(color)
    # connect children w parent (child aware of parent)
    # also connect parent w child  (parent aware of child)
    # add both child && parent to bags 

    children.each do |child|
      if (color = child["bag_color"]) && (count = child["bag_count"])
        child_bag = bags[color]? || Bag.new(color)
        child_bag.outer_bags.push parent_bag
        parent_bag.inner_bags[child_bag] = count.to_u32
        bags[color] = child_bag
      end 
    end 
  end 
  
  return bags 
end 

def solve_part_1(puzzle)
  bags = parse(puzzle)

  ancestor_bags = Set(String).new
  # {"jet black", "just black", ...}
  shiny_gold_bag = bags["shiny gold"]
  get_outer_bags_colors(shiny_gold_bag).size 
end 

def get_outer_bags_colors(bag)
  outer_bags_set = Set(String).new
  bag.outer_bags.each do |outer_bag|
    # get current bags outer bag colors 
    outer_bags_set.add(outer_bag.color)

    # get outer outer bags colors and add them with current outer bags colors 
    outer_bags_set.concat(get_outer_bags_colors(outer_bag)) 
  end
  return outer_bags_set
end 

def solve_part_2(puzzle)
  bags = parse(puzzle)
  shiny_gold_bag = bags["shiny gold"]

  return count_inner_bags(shiny_gold_bag)
end 


def count_inner_bags(bag)
  count = bag.inner_bags.sum(0) do |inner_bag, count|
    count + (count_inner_bags(inner_bag) * count)
  end 
  return count
end

p! solve_part_2(INPUT)