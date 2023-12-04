def solve_part_1(diagram)
  lines = diagram.split("\n")
  max_y_diagram = lines.size
  max_x_diagram = lines.first.size
  lines.each_with_index do |line, y|
    num = ""
    line.split.each_with_index do |square, x|
      if square.match(/0-9/)
        num += square
      else
        # have a full number stored in num
        # want to see if its "valid" aka
        # be adjacent to a symbol

        # find dimensions of box
        min_y = y - 1
        max_y = y + 1
        min_x = x - num.size - 1
        max_x = x

        symbol_in_perimeter?(min_y, max_y, min_x, max_x, lines)
      end
    end
  end
end

def symbol_in_perimeter?(min_y, max_y, min_x, max_x, diagram_lines)

  max_x_diagram = diagram_lines.first.size - 1
  max_y_diagram = diagram_lines.size - 1

  (min_x..max_x).each do |x|

    # is the current x even within bounds?
    next if (x < 0 || x > max_x_diagram)


      #top line
    if (  min_y >= 0 && # within bounds
          lines[min_y][x].match(/[^\w\s\.]/)
      )
        return true
    end

    # bottom line
    if (  max_y <= diagram_lines.size && # within bounds
          lines[max_y][x].match(/[^\w\s\.]/
        )
      return true


    end

  end

  min_x

  return false

end

ex = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598.."

solve_part_1(ex)
