#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include <string.h>

int splitSum(const int* nums, const int numsSize, int* result[2], int returnColumnSizes[2]) {
    int totalLeft = 0;
    int totalRight = 0;
    int left = 0;
    int right = numsSize - 1;

    // Empty array or single element array.
    if (right < 1) {
        returnColumnSizes[0] = 0;
        returnColumnSizes[1] = 0;
        return 1;
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
        left++;
        right++;
        returnColumnSizes[0] = left;
	memcpy(result[0], nums, left * sizeof(int));
        returnColumnSizes[1] = numsSize - right;
        memcpy(result[1], nums + right, (numsSize - right) * sizeof(int));
        return 0;
    }

    // Check middle in the right group.
    if (totalLeft == totalRight + nums[right]) {
        returnColumnSizes[0] = left;
        memcpy(result[0], nums, left * sizeof(int));
        returnColumnSizes[1] = numsSize - right;
        memcpy(result[1], nums + right, (numsSize - right) * sizeof(int));
        return 0;
    }
    returnColumnSizes[0] = 0;
    returnColumnSizes[1] = 0;
    return 1;
}

// Globals so they aren't reallcoated on the stack each invocation.
int* result[2];
int returnColumnSizes[2];
int cases[][8] = { {   0,   0,   0,   0,   0,   0,   0,   0 },
                   {   1, 100,   0,   0,   0,   0,   0,   0 },
                   {   2,  99,  99,   0,   0,   0,   0,   0 },
                   {   3,  98,   1,  99,   0,   0,   0,   0 },
                   {   3,  99,   1,  98,   0,   0,   0,   0 },
                   {   4,   1,   2,   3,   0,   0,   0,   0 },
                   {   4,   1,   2,   3,   5,   0,   0,   0 },
                   {   5,   1,   2,   2,   1,   0,   0,   0 },
                   {   5,  10,  11,  12,  16,  17,   0,   0 },
                   {   7,   1,   1,   1,   1,   1,   1,   6 },
                   {   7,   6,   1,   1,   1,   1,   1,   1 },
                 };

// Test cases
void testCases(int toScreen) {

    for (int i = 0;i < (sizeof(cases) / sizeof(cases[0]));++i) {
        if (toScreen) {
            printf("c: [");
            for (int j = 1;j < cases[i][0] + 1;++j) {
                printf("%s%d", j == 1 ? "" : " ,", cases[i][j]);
            }
            printf("] -> [[");
            splitSum(&cases[i][1], cases[i][0], result, returnColumnSizes);
            for (int j = 0;j < returnColumnSizes[0];++j) {
                printf("%s%d", j == 1 ? "" : " ,", result[0][j]);
            }
            printf("] [");
            for (int j = 0;j < returnColumnSizes[1];++j) {
                printf("%s%d", j == 1 ? "" : " ,", result[1][j]);
            }
            printf("]]\n");
        } else {
            splitSum(&cases[i][1], cases[i][0], result, returnColumnSizes);
        }
    }
}

int main() {
    // Pre-allocate return space.
    result[0] = (int*)malloc(sizeof(cases[0]) / sizeof(cases[0][0]));
    result[1] = (int*)malloc(sizeof(cases[0]) / sizeof(cases[0][0]));

    testCases(1);

    clock_t start_time = clock();

    for (int i = 0; i < 1000000; i++) {
        testCases(0);
    }

    clock_t end_time = clock();
    double elapsed_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf("c: %.3f seconds\n", elapsed_time);

}
