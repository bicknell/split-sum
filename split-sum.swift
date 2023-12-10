import Foundation

func splitSum(nums: [Int]) -> [[Int]] {
    var totalLeft = 0
    var totalRight = 0
    var left = 0
    var right = nums.count - 1

    // Empty array or single element array.
    if right < 1 {
        return [[], []]
    }

    // Sum until the indexes meet in the middle.
    while right != left {
        if totalLeft <= totalRight {
            totalLeft += nums[left]
            left += 1
        } else {
            totalRight += nums[right]
            right -= 1
        }
    }

    // Check middle in the left group.
    if (totalLeft + nums[left]) == totalRight {
        return [Array(nums[0...left]), Array(nums[(right + 1)...])]
    }
    // Check middle in the right group.
    if totalLeft == (totalRight + nums[right]) {
        return [Array(nums[0...left-1]), Array(nums[right...])]
    }
    return [[], []]
}

// Global so they aren't reallcoated on the stack each invocation.
let cases: [[Int]] = [ [ ],
                       [ 100 ],
                       [ 99, 99 ],
                       [ 98, 1, 99],
                       [ 99, 1, 98],
                       [ 1, 2, 3, 0],
                       [ 1, 2, 3, 5],
                       [ 1, 2, 2, 1, 0],
                       [ 10, 11, 12, 16, 17],
                       [ 1, 1, 1, 1, 1, 1, 6 ],
                       [ 6, 1, 1, 1, 1, 1, 1 ],
                     ]

// Test cases
func testCases(toScreen: Bool) {

    for c in cases {
        if toScreen {
            print("swift: ", c, "-> \(splitSum(nums: c))")
        } else {
            _ = splitSum(nums: c)
        }
    }

}

func main() {
    testCases(toScreen: true)

    let startTime = DispatchTime.now()

    for _ in 0..<1_000_000 {
        testCases(toScreen: false)
    }

    let endTime = DispatchTime.now()
    let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let elapsedTime = Double(nanoTime) / 1_000_000_000

    print("splitSum: \(elapsedTime) seconds")
}

main()


