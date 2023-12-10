
from typing import List
from timeit import Timer

def splitSum(nums: List[int]) -> List[List[int]]:

    totalLeft = 0
    totalRight = 0
    left = 0
    right = len(nums) - 1

    # Empty array, or single element array.
    if right < 1:
        return [ [ ], [ ] ]

    # Sum until the indexes meet in the middle.
    while right != left:
        if totalLeft <= totalRight:
            totalLeft = totalLeft + nums[left]
            left = left + 1
        else:
            totalRight = totalRight + nums[right]
            right = right - 1

    # Check middle in left group.
    if (totalLeft + nums[left]) == totalRight:
        return [ nums[0:left + 1], nums[right + 1:] ]
    # Check middle in right group.
    if totalLeft == (totalRight + nums[right]):
        return [ nums[0:left], nums[right:] ]
    return [ [ ], [ ] ]

# Global so they aren't reallcoated on the stack each invocation.
cases = [ [ ],
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
def testCases(toScreen: bool):
    for c in cases:
        if toScreen:
            print("python3: ", c, " -> ", splitSum(c))
        else:
            splitSum(c)
    
testCases(True)

t = Timer(lambda: testCases(False))
print("python3: ", '{:.3f}'.format(t.timeit(number=1000000)), "seconds")
