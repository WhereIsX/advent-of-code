const raw = document.querySelector('pre').innerText
const parsed = raw.split('\n')

function find_most_common_bits(list) {
  // gamma is finding the most common bits for each position 
  // in the list of numbers
  const sample_number = list[0] 
  const tally = new Array(sample_number.length).fill(0)

  console.log(typeof list)
  list.forEach((number)=> {
    bits = number.split('')
    console.log(typeof bits)
    bits.forEach((bit, i) => {
      if (bit === '1') {
        tally[i] += 1 
      }
    })
  })

  most_common = tally.map((number) => {
    if (number > list.length / 2) {
      return 1
    } else {
      return 0
    }
  })
  most_common_as_deci = parseInt(most_common.join(''), 2)

  least_common = most_common.map((most_common) => {
    return most_common === 1 ? 0 : 1
  })

  least_common_as_deci = parseInt(least_common.join(''), 2)

  console.log(most_common, most_common_as_deci, least_common, least_common_as_deci)
  return most_common_as_deci * least_common_as_deci
}

// number[]
function get_bits_by_place(list, place) {
  return list.map((number) => {
    parseInt(number[place], 10)
  })
}

// 1 | 0 | null
function most_common_bit(list) {
  count = list.reduce((acc, number) => acc + number)
  total = list.length

  if (count > total / 2) {
    return 1     
  } else if ( count === total / 2) {
    return null 
  } else {
    return 0
  }
}

function recursively_gather_bits(list, place = 0, ans = []) {
  if (ans.length === list[0].length) {
    return ans 
  }
  bits = get_bits_by_place(list, place)
  most_common = most_common_bit(bits))
  list = list.filter((number) => {
    number[place] === most_common
  })
  recursively_gather_bits(list, place + 1, ans)
}

