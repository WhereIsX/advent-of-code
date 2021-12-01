const input = document.querySelector('pre').innerText
const parsed = input.split("\n").map(num_as_string =>  parseInt(num_as_string ))

function solve_part_1 () {
  return adjacent_increases(parsed)
}

function solve_part_2 () {
  return adjacent_increases(get_sliding_window_sum(parsed))
}

function adjacent_increases (list_of_depths: number[]) {
  let times_increased = 0

  for(let i = 1; i < parsed.length; i++) {
    const curr = list_of_depths[i]
    const prev = list_of_depths[i-1]

    if (curr > prev) {
      times_increased++
    }
  }
  return times_increased
}

function get_sliding_window_sum (list_of_depths: number[]) {
  return list_of_depths.map((n, i) => {
    if (i < 2) {
      return undefined
    }
    const num1 = list_of_depths[i-2]
    const num2 = list_of_depths[i-1]
    const num3 = list_of_depths[i]
    return num1 + num2 + num3
  }).filter((number) => number !== undefined)
}