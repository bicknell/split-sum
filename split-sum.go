
package main

import (
    "fmt"
    "time"
)

func splitSum(nums []int) [][]int {
    totalLeft := 0
    totalRight := 0
    left := 0
    right := len(nums) - 1

    // Empty array or single element array.
    if right < 1 {
        return [][]int{{}, {}}
    }

    // Sum until the indexes meet in the middle.
    for right != left {
        if totalLeft <= totalRight {
            totalLeft += nums[left++]
        } else {
            totalRight += nums[right--]
        }
    }

    // Check middle in the left group.
    if totalLeft+nums[left] == totalRight {
        return [][]int{nums[:left+1], nums[right+1:]}
    }
    // Check middle in the right group.
    if totalLeft == totalRight+nums[right] {
        return [][]int{nums[:left], nums[right:]}
    }
    return [][]int{{}, {}}
}


// Global so they aren't reallcoated on the stack each invocation.
var cases = [][]int{ { },
                     { 100 },
                     { 99, 99 },
                     { 98, 1, 99},
                     { 99, 1, 98},
                     { 1, 2, 3, 0},
                     { 1, 2, 3, 5},
                     { 1, 2, 2, 1, 0},
                     { 10, 11, 12, 16, 17},
                     { 1, 1, 1, 1, 1, 1, 6 },
                     { 6, 1, 1, 1, 1, 1, 1 },
                   }

// Test cases
func testCases(toScreen bool) {

    for _, c := range cases {
        if toScreen {
            fmt.Println("go: ", c, " -> ", splitSum(c));
        } else {
            splitSum(c);
        }
    }
}

func main() {
    testCases(true);

    startTime := time.Now()

    for i := 0; i < 1000000; i++ {
        testCases(false);
    }

    elapsedTime := time.Since(startTime)

    fmt.Printf("go: %.3f seconds\n", elapsedTime.Seconds())
}

