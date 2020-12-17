require "./input_16.cr"

example = "
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"
example2 = "
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
"
example2ans = %w(row class seat)

def parse(puzzle)
  raw_requirements, my_ticket, nearby_tickets = puzzle.split("\n\n", remove_empty: true)

  # {"class" => [1..3, 5..7], "row" => [0..5, 8..19]} 
  requirements = Hash(String, Array(Range(Int32,Int32))).new
  
  raw_requirements.split("\n", remove_empty: true).each do |requirement|
    field, ranges = requirement.split(": ")
    ranges = ranges.split(" or ").map do |range|
      num1, num2 = range.split("-")
      (num1.to_i..num2.to_i)
    end 
    requirements[field] = ranges
  end

  # [ints]
  my_ticket = my_ticket.split("\n").last.split(",").map(&.to_i)

  # [[ints], ...]
  nearby_tickets = nearby_tickets.split("\n", remove_empty: true).[1..].map do |ticket|
    ticket.split(",").map(&.to_i)
  end 

  return {requirements, my_ticket, nearby_tickets}
end   

def solve_part_1(puzzle)
  requirements, my_ticket, nearby_tickets = parse(puzzle)

  ranges = requirements.values.flatten 

  invalid_values = Array(Int32).new
  nearby_tickets.flatten.each do |value|
    if ranges.map{ |range| !range.includes?(value) }.all? 
      invalid_values.push value
    end 
  end 
  return invalid_values.sum
end 

def solve_part_2(puzzle)
  requirements, my_ticket, nearby_tickets = parse(puzzle)

  valid_tickets = find_valid_tickets(nearby_tickets, requirements) 
  
  # slice the tickets vertically 
  # each slice => find the field for which all the values are valid 
  
  columns = Array(Array(Int32)).new
  valid_tickets.first.size.times do |i|
    column = valid_tickets.map do |valid_ticket|
      valid_ticket[i]
    end  
    columns << column 
  end 

  # take one column
  # take all the values in the column, one by one 
  # see if theyre included in the range for one field 
  # if not, go to next field 
  # if yes, go to the next value 

  # requirements # {"class" => [1..3, 5..7], "row" => [0..5, 8..19]} 
 
  fields_order = columns.map do |column| 
    viable_fields = requirements.keys 
    column.each do |value|

      viable_fields = viable_fields.select do |viable_field|
        ranges = requirements[viable_field] 
        within_first_range = ranges.first.includes?(value) 
        within_second_range = ranges.last.includes?(value) 
        within_first_range || within_second_range
      end 

    end 
    viable_fields
  end 

  bad_practice = resolve_to_one_field_per_column(fields_order)
  final_values = Array(Int64).new
  bad_practice.each.with_index do |field,  index|
    if field.starts_with?("departure" )
      final_values << my_ticket[index].to_i64
    end 
  end 
  raise "wat" if final_values.size != 6 
  return final_values.product
end


def resolve_to_one_field_per_column(fields)
  final_order = Array.new(fields.size, "")
  fields_to_remove = Array(String).new

  loop do  
    fields.each.with_index.find do |field, i|
      if field.size == 1 
        final_order[i] = field.first
        fields_to_remove.push(field.first) 
      end 
    end 
    # ["row"]
    break if fields_to_remove.empty? 
    
    fields = fields.map do |field|
      fields_to_remove.each do |field_to_remove|
        field.delete(field_to_remove)
      end 
      field 
    end 
    fields_to_remove.clear
  end 

  return final_order 
end

def find_valid_tickets(tickets, requirements)
  requirements

  ranges = requirements.values.flatten 

  valid_tickets = Array(Array(Int32)).new
  tickets.each do |ticket|
    valid_ticket = true
    # ticket is an [Ints, ...]
    ticket.each do |value|
      if ranges.map{ |range| !range.includes?(value) }.all?
        valid_ticket = false 
        break
      end
    end
    valid_tickets << ticket if valid_ticket
  end 
  
  return valid_tickets
end 

p! solve_part_2(INPUT)
p! example2ans