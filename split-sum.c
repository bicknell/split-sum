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
// list must be longer than the longest case
// recommend list be a multiple of 64 bits (8 bytes) for alignment
struct caseHolder {
    int list[16];
    int elements;
} cases[] = { { .list = { 0 }, .elements = 0},
              { .list = { 100 }, .elements = 1},
              { .list = { 99, 99 }, .elements = 2},
              { .list = { 99, 1, 98 }, .elements = 3},
              { .list = { 98, 1, 99 }, .elements = 3},
              { .list = { 1, 2, 3, 0 }, .elements = 4},
              { .list = { 1, 2, 2, 1, 0 }, .elements = 5},
              { .list = { 10, 11, 12, 16, 17 }, .elements = 5},
              { .list = { 1, 1, 1, 1, 1, 1, 6 }, .elements = 7},
              { .list = { 6, 1, 1, 1, 1, 1, 1 }, .elements = 7},
            };

// Test cases
void testCases(int toScreen) {

    for (int i = 0;i < (sizeof(cases) / sizeof(cases[0]));++i) {
        if (toScreen) {
            printf("c: [");
            for (int j = 0;j < cases[i].elements;++j) {
                printf("%s%d", j ? "," : "", cases[i].list[j]);
            }
            printf("] -> [[");
            splitSum(cases[i].list, cases[i].elements, result, returnColumnSizes);
            for (int j = 0;j < returnColumnSizes[0];++j) {
                printf("%s%d", j ? "," : "", result[0][j]);
            }
            printf("],[");
            for (int j = 0;j < returnColumnSizes[1];++j) {
                printf("%s%d", j ? "," : "", result[1][j]);
            }
            printf("]]\n");
        } else {
            splitSum(cases[i].list, cases[i].elements, result, returnColumnSizes);
        }
    }
}

int main() {
    int max = 0;

    for (int i = 0;i < (sizeof(cases) / sizeof(cases[0]));++i) {
        if (cases[i].elements > max) {
            max = cases[i].elements;
        }
    } 

    // Pre-allocate return space.
    result[0] = (int*)malloc(max * sizeof(int));
    result[1] = (int*)malloc(max * sizeof(int));

    testCases(1);

    clock_t start_time = clock();

    for (int i = 0; i < 1000000; i++) {
        testCases(0);
    }

    clock_t end_time = clock();
    double elapsed_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
    printf("c: %.3f seconds\n", elapsed_time);

}
