require 'pry-nav'

module AOC2019D04

  # It is a six-digit number.
  # The value is within the range given in your puzzle input.
  # Two adjacent digits are the same (like 22 in 122345).
  # Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

  def within_range?(number, range)
    range.include?(number)
  end

  def two_adjacent?(number)
    digits = number.digits
    last_digit = nil

    digits.each do |digit|
      if last_digit == digit
        return true
      else
        last_digit = digit
      end
    end
    return false
  end

  def all_matching_locations(number)
    # return a range for the beginning and end of the matching group

    digits = number.digits

    # IMPLEMENTATION: LOOK FORWARD
    # what is the concept of matching?
    # we seem to go from "nothing matchnes" to
    # these two match.  but we wouldn't say 1 match.
    # it seems like matching is either 0 or 2 and above
    # skipping over the number 1.

    adjacent_matching = 0
    locations = []
    digits.each.with_index do |digit, i|
      next_digit = digits[i+1]
      if digit == next_digit
        adjacent_matching += 1
      elsif digit != next_digit
        locations << (i - adjacent_matching ..i)
        adjacent_matching = 0
      end
    end

    return locations

    # IMPLEMENTATION: LOOK BACK

    # last_digit = nil
    # consecutive_match = 0 # 1 => two matching
    #                       # 2 => three matching
    #                       # 3 => four matching;   count is off by 1
    # location = []
    #
    # digits.each.with_index do |digit, i|
    #
    #   if last_digit.nil?
    #     last_digit = digit
    #
    #   elsif last_digit == digit
    #     consecutive_match += 1
    #
    #   elsif last_digit != digit
    #     binding.pry
    #     if consecutive_match >= 2
    #       location.push (i - consecutive_match + 1 ...i)
    #     end
    #     consecutive_match = 0
    #   end
    #
    # end
    #
    # if consecutive_match >= 2
    #   location.push (digits.length - consecutive_match +1 ...digits.length)
    # end
    #
    # return location
  end

  def two_adjacent_not_part_of_larger_group?(num)
    matching_sizes = all_matching_locations(num).collect do |matching_group|
      matching_group.size
    end
    matching_sizes.include?(2)
  end

  def digits_only_increase?(number)
    digits = number.digits
    last_digit = nil
    digits.each do |digit|
      if last_digit.nil?
        last_digit = digit
      elsif digit <= last_digit
        last_digit = digit
      elsif digit > last_digit
        return false
      end
    end
    return true
  end

  def satisfactory_number?(number)
    two_adjacent?(number)         &&
    digits_only_increase?(number)
  end

  def solve_part_1(range)
    nums_that_satisfy = 0
    range.each do |num|
      nums_that_satisfy +=1 if satisfactory_number?(num)
    end
    return nums_that_satisfy
  end


  def solve_part_2(range)
    nums_that_satisfy = 0
    range.each do |num|
      if satisfactory_number?(num) && two_adjacent_not_part_of_larger_group?(num)
        nums_that_satisfy +=1
      end
    end
    nums_that_satisfy
  end

end

include AOC2019D04


range = (171309..643603)
# we are lucky that our particular range begins with a 1
# if it began with a 0, and is a 6-digit number, ruby interprets that as a hexadecimal?

p solve_part_2(range)


# TESTS

{
  # 111111 => true,
  223450 => false,
  123789 => false,
  111123 => true,
  122345 => true,
}.each_pair do |num, ans|
  p satisfactory_number?(num) == ans
end

{ 112233 => true ,
  111122 => true ,
  123444 => false }.each_pair do |num, ans|
  p satisfactory_number?(num) && two_adjacent_not_part_of_larger_group?(num) == ans
end
