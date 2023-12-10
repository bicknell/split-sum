
#[macro_use(lazy_static)]
extern crate lazy_static;
use std::boxed::Box;

pub struct Global;

fn split_sum(nums: &Box<[i32]>) -> Box<[&[i32]; 2]> {
    let mut total_left: i32 = 0;
    let mut total_right: i32 = 0;
    let mut left: usize = 0;
    let mut right: usize = 0;

    if nums.len() > 0 {
        right = nums.len() - 1;
    }

    // Empty array or single element array.
    if right < 1 {
        return Box::new([ &[], &[] ]);
    }

    // Sum until the indexes meet in the middle.
    while right != left {
        if total_left <= total_right {
            total_left += nums[left];
            left += 1;
            continue;
        }

        // otherwise totalLeft > totalRight
        total_right += nums[right];
        right -= 1;
    }

    // Check middle in the left group.
    if total_left + nums[left] == total_right {
        return Box::new([&nums[0..(left + 1)], &nums[(right + 1)..]]);
    }
    // Check middle in the right group.
    if total_left == total_right + nums[right] {
        return Box::new([&nums[0..left], &nums[right..]]);
    }
    return Box::new([ &[], &[] ]);
}

// Global so they aren't reallcoated on the stack each invocation.
lazy_static! {
    static ref CASES: [Box<[i32]>; 10] = [ Box::new([]),
                                           Box::new([100]),
                                           Box::new([99, 99]),
                                           Box::new([98, 1, 99]),
                                           Box::new([99, 1, 98]),
                                           Box::new([1, 2, 3, 0]),
                                           Box::new([1, 2, 2, 1, 0]),
                                           Box::new([10, 11, 12, 16, 17]),
                                           Box::new([1, 1, 1, 1, 1, 1, 6]),
                                           Box::new([6, 1, 1, 1, 1, 1, 1])
                                         ];
}

// Test cases
fn test_cases(to_screen: bool) {
 
    for (_i, c) in CASES.iter().enumerate() {
        if to_screen {
            println!("rust: {:?} -> {:?}", c, split_sum(c));
        } else {
            split_sum(c);
        }
    }
}

fn main() {

    test_cases(true);

    let start_time = std::time::Instant::now();

    for _ in 0..1_000_000 {
        test_cases(false);
    }

    let elapsed_time = start_time.elapsed();

    println!("rust: {:.3} seconds", elapsed_time.as_secs_f32());
}

