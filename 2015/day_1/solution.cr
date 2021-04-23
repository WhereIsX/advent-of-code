require "./input.cr"

# part 1
parens = INPUT.chars
puts (parens.count '(') - (parens.count ')')

floor = 0
parens.each_with_index do |paren, i|
  if paren == '('
    floor += 1
  else
    floor -= 1
  end
  if floor == -1
    puts i + 1
    break
  end
end
