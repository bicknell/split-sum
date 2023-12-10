#include <iostream>
#include <sstream>
#include <vector>

std::vector<std::vector<int> > splitSum(const std::vector<int>& nums) {
    int totalLeft = 0;
    int totalRight = 0;
    int left = 0;
    int right = nums.size() - 1;

    // Empty array or single element array.
    if (right < 1) {
        return {{}, {}};
    }

    // Sum until the indexes meet in the middle.
    while (right != left) {
        if (totalLeft <= totalRight) {
            totalLeft += nums[left++];
        } else {
            totalRight += nums[right--];
        }
    }

    // Check middle in the left group.
    if (totalLeft + nums[left] == totalRight) {
        return {{nums.begin(), nums.begin() + left + 1}, {nums.begin() + right + 1, nums.end()}};
    }
    // Check middle in the right group.
    if (totalLeft == totalRight + nums[right]) {
        return {{nums.begin(), nums.begin() + left}, {nums.begin() + right, nums.end()}};
    }
    return {{}, {}};
}

// Global so they aren't reallcoated on the stack each invocation.
std::vector<std::vector<int> > cases { {  },
                                       {  100 },
                                       {   99,  99 },
                                       {   98,   1,  99 },
                                       {   99,   1,  98 },
                                       {    1,   2,   3,   0 },
                                       {    1,   2,   3,   5 },
                                       {    1,   2,   2,   1,   0 },
                                       {   10,  11,  12,  16,  17 },
                                       {    1,   1,   1,   1,   1,   1,   6 },
                                       {    6,   1,   1,   1,   1,   1,   1 },
                                     };

// Test cases
void testCases(bool toScreen) {

    // Iterate through the outer vector (rows)
    for (size_t i = 0; i < cases.size(); ++i) {
       if (toScreen) {
           std::cout << "c++: {";
           for (size_t j = 0; j < cases[i].size(); ++j) {
               std::cout << cases[i][j] << ", ";
           }
           std::cout << "} -> {";
           std::vector<std::vector<int> > result = splitSum(cases[i]);
           for (size_t x = 0; x < result.size(); ++x) {
               std::cout << " {";
               for (size_t y = 0; y < result[x].size(); ++y) {
                   std::cout << result[x][y] << ", ";
               }
               std::cout << "}";
           }
           std::cout << " }" << std::endl;
       } else {
           splitSum(cases[i]);
       } 
    }
}


int main() {
    testCases(true);

    clock_t start_time = clock();

    for (int i = 0; i < 1000000; i++) {
        testCases(false);
    }

    clock_t end_time = clock();
    double elapsed_time = static_cast<double>(end_time - start_time) / CLOCKS_PER_SEC;
    std::cout << "c++: " << elapsed_time << " seconds" << std::endl;

    return 0;
}

