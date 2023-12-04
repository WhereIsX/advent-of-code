package main

import (
	"fmt"
	"io/ioutil"
)

type testcase struct {
	input    string
	expected int
}

func main() {
	// run the tests!
	fmt.Println(test()) // expecting [true, true]

	// the actual work :>
	superImportant, e := ioutil.ReadFile("input")
	if e == nil {
		first := solve(string(superImportant))
		second := solveTwo(string(superImportant))
		fmt.Println(first, second)
	} else {
		fmt.Println("ya wat")
	}

}

func solve(problem string) int {
	floor := 0

	for _, char := range problem {
		if char == '(' {
			floor += 1
		} else if char == ')' {
			floor -= 1
		}
	}
	// ups := strings.Count(problem, "(")
	// downs := strings.Count(problem, ")")
	// return (ups - downs)
	return floor

}

func solveTwo(problem string) int {
	floor := 0
	for i, char := range problem {
		if char == '(' {
			floor += 1
		} else if char == ')' {
			floor -= 1
		}
		if floor < 0 {
			actual_position := i + 1
			return actual_position
		}
	}
	return -1
}

func test() [2]bool {
	ex := [2]testcase{
		{
			input:    "(())",
			expected: 0,
		},
		{
			input:    "))(((((",
			expected: 3,
		},
	}

	var answers [2]bool
	for i, test := range ex {
		answers[i] = (solve(test.input) == test.expected)
	}
	return answers
}
