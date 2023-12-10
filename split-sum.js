
function splitSum(nums) {
    let totalLeft = 0;
    let totalRight = 0; let left = 0;
    let right = nums.length - 1;

    // Empty array, or single element array.
    if (right < 1) {
        return [[], []];
    }

    // Sum until the indexes meet in the middle.
    while (right !== left) {
        if (totalLeft <= totalRight) {
            totalLeft += nums[left];
            left += 1;
        } else {
            totalRight += nums[right];
            right -= 1;
        }
    }

    // Check middle in left group.
    if (totalLeft + nums[left] === totalRight) {
        return [nums.slice(0, left + 1), nums.slice(right + 1)];
    }
    // Check middle in right group.
    if (totalLeft === totalRight + nums[right]) {
        return [nums.slice(0, left), nums.slice(right)];
    }
    return [[], []];
}

// Global so they aren't reallcoated on the stack each invocation.
const cases = [
    [],
    [100],
    [99, 99],
    [98, 1, 99],
    [99, 1, 98],
    [1, 2, 3, 0],
    [1, 2, 3, 5],
    [1, 2, 2, 1, 0],
    [10, 11, 12, 16, 17],
    [1, 1, 1, 1, 1, 1, 6],
    [6, 1, 1, 1, 1, 1, 1],
];

// Test cases
function testCases(toScreen) {

    for (const c of cases) {
        if (toScreen) {
            console.log("javascript: ", JSON.stringify(c), " -> ", JSON.stringify(splitSum(c)));
        } else {
            splitSum(c);
        }
    }
}

testCases(true);

const startTime = Date.now();
for (let i = 0; i < 1000000; i++) {
    testCases(false);
}
const elapsedTime = (Date.now() - startTime) / 1000; // Convert to seconds
console.log("javascript: " + elapsedTime.toFixed(3) + " seconds");

