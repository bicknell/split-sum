#import <Foundation/Foundation.h>

NSArray<NSArray<NSNumber *> *> *splitSum(const NSArray<NSNumber *> *nums) {
    NSInteger totalLeft = 0;
    NSInteger totalRight = 0;
    NSInteger left = 0;
    NSInteger right = [nums count] - 1;

    // Empty array or single element array.
    if (right < 1) {
        return @[@[], @[]];
    }

    // Sum until the indexes meet in the middle.
    while (right != left) {
        if (totalLeft <= totalRight) {
            totalLeft += [nums[left] integerValue];
            left++;
        } else {
            totalRight += [nums[right] integerValue];
            right--;
        }
    }

    // Check middle in the left group.
    if ((totalLeft + [nums[left] integerValue]) == totalRight) {
        return @[[nums subarrayWithRange:NSMakeRange(0, left + 1)], [nums subarrayWithRange:NSMakeRange(right + 1, [nums count] - right - 1)]];
    }
    // Check middle in the right group.
    if (totalLeft == (totalRight + [nums[right] integerValue])) {
        return @[[nums subarrayWithRange:NSMakeRange(0, left)], [nums subarrayWithRange:NSMakeRange(right, [nums count] - right)]];
    }
    return @[@[], @[]];
}

// Global so they aren't reallcoated on the stack each invocation.
NSArray<NSArray<NSNumber *> *> *cases = @[ @[],
                                           @[@100],
                                           @[@99, @99],
                                           @[@98, @1, @99],
                                           @[@99, @1, @98],
                                           @[@1, @2, @3, @0],
                                           @[@1, @2, @3, @5],
                                           @[@1, @2, @2, @1, @0],
                                           @[@10, @11, @12, @16, @17],
                                           @[@1, @1, @1, @1, @1, @1, @6],
                                           @[@6, @1, @1, @1, @1, @1, @1],
                                         ];

// Test cases
void testCases(bool toScreen) {
    @autoreleasepool {
        for (NSArray<NSNumber *> *c in cases) {
            if (toScreen) {
                NSMutableString *outStr = [NSMutableString stringWithString:@"objective-c: {"];

                [c enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger i, BOOL *stop) {
                    [outStr appendFormat:@"%s%@", i ? ", " : "", number];
                }];

                [outStr appendString:@"} -> {"];

                [splitSum(c) enumerateObjectsUsingBlock:^(NSArray *result, NSUInteger i, BOOL *stop) {
                    [outStr appendFormat:@"%s{", i ? ", " : ""];
                    [result enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger j, BOOL *stop) {
                        [outStr appendFormat:@"%s%@", j ? ", " : "", number];
                    }];
                    [outStr appendString:@"}"];
                }];
                [outStr appendString:@"}"];
                puts([outStr UTF8String]);
            } else {
                splitSum(c);
            }
        }
    }
}
    
int main(int argc, const char * argv[]) {
    testCases(true);

    @autoreleasepool {
        NSDate *startTime = [NSDate date];
        for (int i = 0; i < 1000000; i++) {
            testCases(false);
        }
        NSDate *endTime = [NSDate date];
        NSTimeInterval elapsedTime = [endTime timeIntervalSinceDate:startTime];
        puts([ [NSString stringWithFormat:@"objective-c: %.3f seconds", elapsedTime ] UTF8String]);
    }
    return 0;
}

