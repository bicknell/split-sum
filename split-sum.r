splitSum <- function(nums) {
  totalLeft <- 0
  totalRight <- 0
  left <- 1
  right <- length(nums)

  # Empty array or single element array.
  if (right < 2) {
    return(list(list(),list()))
  }

  while (right != left) {
    if (totalLeft <= totalRight) {
      totalLeft <- totalLeft + nums[[left]]
      left <- left + 1
    } else {
      totalRight <- totalRight + nums[[right]]
      right <- right - 1
    }
  }

  # Check middle in the left group.
  if ((totalLeft + nums[[left]]) == totalRight) {
    left <- left + 1
    result1 <- nums[1:left-1]
    result2 <- nums[(right + 1):length(nums)]
    return(list(result1, result2))
  }
  
  # Check middle in the right group.
  if (totalLeft == (totalRight + nums[[right]])) {
    result1 <- nums[1:left-1]
    result2 <- nums[right:length(nums)]
    return(list(result1, result2))
  }

  return(list(result1 = list(),result2 = list()))
}

# Global so they aren't reallcoated on the stack each invocation.
cases <- list(
  case1 = list(),
  case2 = list(100),
  case3 = list(99, 99),
  case4 = list(98, 1, 99),
  case5 = list(99, 1, 98),
  case6 = list(1, 2, 3, 0),
  case7 = list(1, 2, 3, 5),
  case8 = list(1, 2, 2, 1, 0),
  case9 = list(10, 11, 12, 16, 17),
  case10 = list(1, 1, 1, 1, 1, 1, 6),
  case11 = list(6, 1, 1, 1, 1, 1, 1)
)

# Test cases
testCases <- function(toScreen) {

  for (c in cases) {
    if (toScreen) {
      cat("R: ", capture.output(dput(c)), " -> ", capture.output(dput((splitSum(c)))), "\n")
    } else {
      splitSum(c)
    }
  }
}

testCases(TRUE)

startTime <- Sys.time()
for (x in 1:1000000) {
    testCases(FALSE)
}
endTime <- Sys.time()
print(endTime - startTime)
