require "./input_04.cr"

alias PassportInner = NamedTuple(
  byr: UInt32, # (Birth Year)
  iyr: UInt32, # (Issue Year)
  eyr: UInt32, # (Expiration Year)
  hgt: UInt32, # (Height)
  hcl: String, # (Hair Color)
  ecl: String, # (Eye Color)
  pid: String, # (Passport ID)
  #cid: UInt32, # (Country ID)
)
# Things to Validate
# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.

class Passport 
  property byr, iyr, eyr, hgt, hcl, ecl, pid, cid
  
  def initialize(hash)
    # pass validations before generating the PassportInner 

    passport = PassportInner(hash)
  end 

  def valid_byr?(byr)
    (1920..2002).include?(byr)
  end 

  def valid_iyr?(iyr)
    (2010..2020).include?(iyr)
  end 



end

def parse( puzzle_input )
  passports = puzzle_input.split("\n\n").map do |passport|
    stuff = passport.split(/[\n\ ]/, remove_empty: true)
    # ["eyr:icl", "byr:1992", ...]
    # we need the opposite of zip actually
    # then we dont need a zip

    hash = {} of String => String
    stuff.each do |kv|
      key, val = kv.split(":")
      hash[key] = val
    end 

    # if we want to use zip then we need to extract all keys first, then extract all values. kinda messy though
    #passaporte = Passport.from hash
    # that one is unable to automatically parse strings into integers, we need to do that manually (or define a function on Passport that can do that)
    # yo how the f does that work
    # yes but how does it infer the types then? ok let's try
    begin
      passaporte = PassportInner.new(
        byr: hash["byr"].to_u32(strict: false),
        iyr: hash["iyr"].to_u32,
        eyr: hash["eyr"].to_u32,
        hgt: hash["hgt"].to_u32(strict: false),
        hcl: hash["hcl"],
        ecl: hash["ecl"],
        pid: hash["pid"],
        # cid: hash["cid"].to_u32,
      )
      passaporte
    rescue ex : KeyError
      puts "KeyError: #{ex.message}"
    end
  end
  passports.compact
end   



def solve_part_1( input )
  passports = parse(input)
  puts passports.size 
end

def solve_part_2( input )
end

example = "
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"

solve_part_1(INPUT) 


require "spec"

RUN_TESTS_PART1 = false
describe "Part 1" do
  if RUN_TESTS_PART1
    describe "parse" do
      it "accurately parses the input" do
        #f = parse( example ) 
        #f.should eq '.'
      end
    end

    describe "solution" do
      it "correctly " do
        #puts solve_part_1(example)
        # 230
      end

      it "correctly calculates the solution for the input" do
        #puts solve_part_1(INPUT)
        # 230
      end
    end
  end
end

RUN_TESTS_PART2 = false
describe "Part 2" do
  if RUN_TESTS_PART2
    describe "solution" do
      it "correctly " do
        #puts solve_part_2(example)
        # 230
      end

      it "correctly calculates the solution for the input" do
        #puts solve_part_2(INPUT)
        # 230
      end
    end
  end
end