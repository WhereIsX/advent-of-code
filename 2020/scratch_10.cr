def parse(puzzle)
  puzzle.split("\n", remove_empty: true).map(&.to_i)
end 

def solve_part_2(puzzle)

  # spawn multiple "windows"
  # that "look" at 3 numbers at a time
  # if the middle number can be removed 
  # the window removes the number
  # and spawns another window (window2)
  # to look at ANOTHER chunk of 3 at a time (minus the num that window1 removed)
  # window2 also asks if the middle number can be removed 
  # if yes, then also removes it, and spawns ANOTHER window (window3)
  # and so on ...
  # if a window cannot remove the middle number 
  # it moves to the next "chunk" of 3 

  adapters = parse(puzzle).sort 

  recursive_window(adapters)
end 

def recursive_window(adapters)
  arrangements = 1
  
  i = 0

  while i < adapters.size - 2
    first, second, third = adapters[i..i+2]


    if (1..3).includes?(third - first) 
      # remove second 
      arrangements += 1 
      puts "\nSKIP MIDDLE NUMBER!"
      p! arrangements 
      p! adapters[i..i+2]
      adapters.delete_at(i+1)

      if adapters.size >= 3 
        puts "\nOPEN NEW WINDOW!"
        new_adapters = adapters.clone
        arrangements += recursive_window(new_adapters)
      end 
    else 
      i += 1
      puts "\nCOULD NOT SKIP MIDDLE NUMBER"
      p! i 
      p! adapters 
    end 
  end 

  puts "\n => CLOSING WINDOW with #{arrangements} arrangements"
  return arrangements 
end 


p! solve_part_2("1
2
3
4


")