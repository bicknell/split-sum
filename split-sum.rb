
def splitSum(nums)
    totalLeft = 0
    totalRight = 0
    left = 0
    right = nums.length - 1

    # Empty array or single element array.
    return [[], []] if right < 1

    while right != left do
        if totalLeft <= totalRight
            totalLeft += nums[left]
            left += 1
        else
            totalRight += nums[right]
            right -= 1
        end
    end

    # Check middle in the left group.
    if totalLeft + nums[left] == totalRight
        return [nums[0..left], nums[right + 1..-1]]
    end
    # Check middle in the right group.
    if totalLeft == totalRight + nums[right]
        return [nums[0..left - 1], nums[right..-1]]
    end
    return [[], []]
end

# Global so they aren't reallcoated on the stack each invocation.
$cases = [ [ ],
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

# Test cases
def testCases(toScreen)

    $cases.each { |c|
        if toScreen
            printf("ruby: %s -> %s\n", c, splitSum(c))
        else
            splitSum(c)
        end
    }
end

def main
    testCases(true)

    start_time = Time.now

    1_000_000.times do
        testCases(false)
    end

    elapsed_time = Time.now - start_time

    printf("ruby: %.3f seconds\n", elapsed_time)
end

main
