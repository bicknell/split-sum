
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class splitSum {

    public static List<List<Integer>> splitSum(List<Integer> nums) {
        int totalLeft = 0;
        int totalRight = 0;
        int left = 0;
        int right = nums.size() - 1;

        // Empty array, or single element array.
        if (right < 1) {
            return Arrays.asList(new ArrayList<>(), new ArrayList<>());
        }

        // Sum until the indexes meet in the middle.
        while (right != left) {
            if (totalLeft <= totalRight) {
                totalLeft = totalLeft + nums.get(left);
                left = left + 1;
                continue;
            }

            // otherwise totalLeft > totalRight
            totalRight = totalRight + nums.get(right);
            right = right - 1;
        }

        // Check middle in left group.
        if (totalLeft + nums.get(left) == totalRight) {
            return Arrays.asList(nums.subList(0, left + 1), nums.subList(right + 1, nums.size()));
        }
        // Check middle in right group.
        if (totalLeft == totalRight + nums.get(right)) {
            return Arrays.asList(nums.subList(0, left), nums.subList(right, nums.size()));
        }
        return Arrays.asList(new ArrayList<>(), new ArrayList<>());
    }

    // Global so they aren't reallcoated on the stack each invocation.
    private static final List<List<Integer>> cases = Arrays.asList(
                                                     Arrays.asList(),
                                                     Arrays.asList(100),
                                                     Arrays.asList(99, 99),
                                                     Arrays.asList(98, 1, 99),
                                                     Arrays.asList(99, 1, 98),
                                                     Arrays.asList(1, 2, 3, 0),
                                                     Arrays.asList(1, 2, 3, 5),
                                                     Arrays.asList(1, 2, 2, 1, 0),
                                                     Arrays.asList(10, 11, 12, 16, 17),
                                                     Arrays.asList(1, 1, 1, 1, 1, 1, 6),
                                                     Arrays.asList(6, 1, 1, 1, 1, 1, 1)
                                                   );

    // Test cases
    public static void testCases(boolean toScreen) {

        for (List<Integer> c : cases) {
            if (toScreen) {
                System.out.println("java: " + c + " -> " + splitSum(c));
            } else {
                splitSum(c);
            }
        }
    }

    public static void main(String[] args) {
        testCases(true);

        long startTime = System.nanoTime();
        for (int i = 0; i < 1000000; i++) {
            testCases(false);
        }
        long elapsedTime = System.nanoTime() - startTime;
        double seconds = (double) elapsedTime / 1_000_000_000.0;
        System.out.println("java: " + String.format("%.3f", seconds) + " seconds");
    }
}

