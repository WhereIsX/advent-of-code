require "./input.cr"

examples = [
  ">",
  "^>v<",
  "^v^v^v^v^v",
]

#
# alias Coordinate = NamedTuple(x: Int32, y: Int32)
# TODO; {{x: x, y: y} = 1} bug </3

def part1(input)
  x = 0_i32
  y = 0_i32
  starting_haus = {x: x, y: y}
  neighborhood = {starting_haus => 1}

  input.chars.each do |direction|
    case direction
    when '^'
      y += 1
    when 'v'
      y -= 1
    when '>'
      x += 1
    when '<'
      x -= 1
    end
    haus = {x: x, y: y}
    # if haus isn't visited yet, insert into neighborhood
    # if haus has already  been visited, update haus visits +1
    neighborhood.merge!({haus => 1}) do |_, existing, new|
      existing + new
    end

    # visualize(neighborhood) # print to the terminal WITH COLORS!
  end

  return neighborhood
end

def get_min_max(neighborhood)
  x_dim = neighborhood.each_key.map { |k| k[:x] }.to_a.sort
  y_dim = neighborhood.each_key.map { |k| k[:x] }.to_a.sort
  return x_dim.first, x_dim.last, y_dim.first, y_dim.last
end

def get_haus_with_most_presents(neighborhood)
  neighborhood.values.max
end

# def hsv_to_rgb(h: Int32, s, v)

def visualize(neighborhood)
  minx, maxx, miny, maxy = get_min_max(neighborhood)
  neighborhood
end

hm = part1(INPUT)
p! get_min_max(hm), get_haus_with_most_presents(hm)
