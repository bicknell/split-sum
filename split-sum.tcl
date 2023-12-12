
# Global so they aren't reallcoated on the stack each invocation.
variable cases { {}
                 {100}
                 {99 99}
                 {98 1 99}
                 {99 1 98}
                 {1 2 3 0}
                 {1 2 3 5}
                 {1 2 2 1 0}
                 {10 11 12 16 17}
                 {1 1 1 1 1 1 6 }
                 {6 1 1 1 1 1 1}
               }

# Define the splitSum function
proc splitSum {nums} {
    set totalLeft 0
    set totalRight 0
    set left 0
    set right [expr {[llength $nums]} - 1]

    # Empty array or single element array.
    if {$right < 1} {
        return [list {} {}]
    }

    # Sum until the indexes meet in the middle.
    while {$right != $left} {
        if {$totalLeft <= $totalRight} {
            set totalLeft [expr {$totalLeft + [lindex $nums $left]}]
            incr left
        } else {
            set totalRight [expr {$totalRight + [lindex $nums $right]}]
            incr right -1
        }
    }

    # Check middle in the left group.
    if {($totalLeft + [lindex $nums $left]) == $totalRight} {
        return [list [lrange $nums 0 $left] [lrange $nums [expr {$right + 1}] end]]
    }
    # Check middle in the right group.
    if {$totalLeft == ($totalRight + [lindex $nums $right])} {
        return [list [lrange $nums 0 [expr {$left - 1}]] [lrange $nums $right end]]
    }
    return [list {} {}]
}

# Test cases
proc testCases {toScreen} {
    global cases

    foreach c $cases {
        if {$toScreen} {
            puts [ format {tcl: {%s} -> {%s}}  $c [ splitSum $c ] ]
        } else {
            splitSum c
        }
    }

}

testCases 1

# Measure execution time
set startTime [clock milliseconds]
    
# Call the splitSum function and display the result in the text widget
for {set i 0} {$i < 100000} {incr i} {
    testCases 0
}

set endTime [clock milliseconds]
set executionTime [expr [expr {$endTime - $startTime}] / 1000.0]
    
# Display the execution time
puts "tcl: ${executionTime} seconds"
