
use Data::Dump qw(dump);
use Time::HiRes;
use Benchmark ':hireswallclock';

sub splitSum(@) {
    my (@nums) = @{$_[0]};

    my $totalLeft = 0;
    my $totalRight = 0;
    my $left = 0;
    my $right = scalar(@nums) - 1;

    # Empty array, or single element array.
    if ($right < 1) {
        return ( [ ], [ ] );
    }

    # Sum until the indexes meet in the middle.
    while ($right != $left) {
        if ($totalLeft <= $totalRight) {
            $totalLeft = $totalLeft + $nums[$left++];
        } else {
            $totalRight = $totalRight + $nums[$right--];
        }
    }

    # Check middle in left group.
    if (($totalLeft + $nums[$left]) == $totalRight) {
        return ( [ @nums[0..$left] ], [ @nums[$right + 1..$#nums] ] )
    }
    # Check middle in right group.
    if ($totalLeft == ($totalRight + $nums[$right])) {
        return ( [ @nums[0..$left-1] ], [ @nums[$right..$#nums] ] );
    }
    return ( [ ], [ ] );
}

# Global so they aren't reallcoated on the stack each invocation.
my $casesRef = [ [ ],
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
               ];

# Test cases
sub testCases(@) {
    my ($toScreen) = @_;


    foreach my $c (@$casesRef) {
        if ($toScreen) {
            print("perl5: ", dump($c), " -> ", dump(splitSum($c)), "\n");
        } else {
            splitSum($c);

}
    }
}

testCases(1);

printf("perl5: %.3f seconds\n",timeit(1000000, 'testCases(0)')->cpu_a);
