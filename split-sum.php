<?php

function splitSum($nums) {
    $totalLeft = 0;
    $totalRight = 0;
    $left = 0;
    $right = count($nums) - 1;

    // Empty array or single element array.
    if ($right < 1) {
        return [ [], [] ];
    }

    // Sum until the indexes meet in the middle.
    while ($right != $left) {
        if ($totalLeft <= $totalRight) {
            $totalLeft += $nums[$left++];
        } else {
            $totalRight += $nums[$right--];
        }
    }

    // Check middle in left group.
    if (($totalLeft + $nums[$left]) == $totalRight) {
        return [ array_slice($nums, 0, $left + 1), array_slice($nums, $right + 1) ];
    }
    // Check middle in right group.
    if ($totalLeft == ($totalRight + $nums[$right])) {
        return [ array_slice($nums, 0, $left), array_slice($nums, $right) ];
    }
    return [ [], [] ];
}

// Global so they aren't reallocated on the stack each invocation.
$cases = [
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
function testCases($toScreen) {
    global $cases;
    foreach ($cases as $c) {
        if ($toScreen) {
            echo "php: " . json_encode($c) . " -> " . json_encode(splitSum($c)) . "\n";
        } else {
            splitSum($c);
        }
    }
}

testCases(true);

$start_time = microtime(true);

for ($i = 0; $i < 1000000; $i++) {
    testCases(false);
}

$end_time = microtime(true);
$elapsed_time = $end_time - $start_time;
echo "php: " . number_format($elapsed_time, 3) . " seconds";
?>

