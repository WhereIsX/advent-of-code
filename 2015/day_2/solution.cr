require "./input.cr"

def parse(input) : Array(Array(Int32))
  input.split("\n", remove_empty: true).map do |dimensions|
    dimensions.split('x', remove_empty: true).map(&.to_i)
  end
end

p! parse(INPUT)

def part1(input)
  package_dimensions = parse(input)

  package_dimensions.reduce(0) do |wrapping_paper, xyz|
    areas = xyz.combinations(size: 2).map do |side|
      side.first * side.last
    end.sort

    total_area = areas.reduce(0) do |acc, n|
      acc + n*2
    end
    wrapping_paper + total_area + areas.first
  end
end

def part2(input)
  package_dimensions = parse(input)
  package_dimensions.reduce(0) do |ribbon, xyz|
    sorted_xyz = xyz.sort
    wrap = sorted_xyz[0] * 2 + sorted_xyz[1] * 2
    bow = xyz[0] * xyz[1] * xyz[2]
    ribbon + wrap + bow
  end
end

def playground
  [1, 2, 3].reduce(0) do |acc, n|
    acc + n*2
  end
end

# p! playground()
p! part1(INPUT)
p! part2(INPUT)
