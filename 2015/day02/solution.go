package main

import (
	"fmt"
	"io/ioutil"
	"sort"
	"strconv"
	"strings"
)

func main() {
	fmt.Println(test())
	fmt.Println(solve(""))
	a := "a"
	b := 'a'
	fmt.Println(a == string(b))
	fmt.Printf("%T %T\n", a, b)
}

func solve(raw_rawr string) int {
	if raw_rawr == "" {
		nibble, err := ioutil.ReadFile("input")
		if err != nil {
			panic("panic?! lost my reading goggles, read again when you can C")
		} else {
			raw_rawr = string(nibble)
		}
	}

	cooked := parse(raw_rawr)

	squareFt := 0
	for _, dimensions := range cooked {
		squareFt += getOne(dimensions)
	}
	return squareFt
}

func parse(puzzle string) [][3]int {
	lines := strings.Split(puzzle, "\n")

	var dimensions [][3]int
	for _, line := range lines {
		nums := strings.Split(line, "x") // []string

		var dimension [3]int
		for i, dim := range nums {
			n, err := strconv.Atoi(dim)
			if err != nil { // if err
				panic("you wat; couldn't parse the string into int")
			} else { // success!
				dimension[i] = n
			}
		}
		dimensions = append(dimensions, dimension)
	}
	return dimensions
}

func getOne(dimensions [3]int) int {
	side1 := dimensions[0] * dimensions[1]
	side2 := dimensions[0] * dimensions[2]
	side3 := dimensions[1] * dimensions[2]

	sides := []int{side1, side2, side3}
	sort.Ints(sides)
	smallest := sides[0]

	return side1*2 + side2*2 + side3*2 + smallest
}

type testCase struct {
	input    string
	expected int
}

func test() [2]bool {
	testCases := [2]testCase{
		{
			input:    "2x3x4",
			expected: 52 + 6,
		},
		{
			input:    "1x1x10",
			expected: 42 + 1,
		},
	}

	var x [2]bool

	for i, tcase := range testCases {
		x[i] = (solve(tcase.input) == tcase.expected)
		if x[i] == false {
			fmt.Println(solve(tcase.input), tcase.expected)
		}
	}

	return x
}
