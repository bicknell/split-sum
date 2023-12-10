#!/bin/bash

splitSum() {
    nums=("$@")
    totalLeft=0
    totalRight=0
    left=0
    right=$((${#nums[@]} - 1))

    # Empty array or single element array.
    if [[ "$right" -lt 1 ]]; then
        echo "[] []"
        return
    fi

    while [[ "$right" -ne "$left" ]]; do
        if [[ "$totalLeft" -le "$totalRight" ]]; then
            totalLeft=$((totalLeft + ${nums[$left]}))
            left=$((left + 1))
        else
            totalRight=$((totalRight + ${nums[$right]}))
            right=$((right - 1))
        fi
    done

    # Check middle in the left group.
    if [[ "$((totalLeft + ${nums[$left]}))" -eq "$totalRight" ]]; then
        leftArray=("${nums[@]:0:$((left + 1))}")
        rightArray=("${nums[@]:$((right + 1))}")
        echo "[${leftArray[@]}] [${rightArray[@]}]"
        return
    fi
    # Check middle in the right group.
    if [[ "$totalLeft" -eq "$((totalRight + ${nums[$right]}))" ]]; then
        leftArray=("${nums[@]:0:$left}")
        rightArray=("${nums[@]:$right}")
        echo "[${leftArray[@]}] [${rightArray[@]}]"
        return
    fi
    echo "[] []"
    return
}

# Global so they aren't reallcoated on the stack each invocation.
cases=(" " \
       "100" \
       "99 99" \
       "98 1 99" \
       "99 1 98" \
       "1 2 3 0" \
       "1 2 3 5" \
       "1 2 2 1 0" \
       "10 11 12 16 17" \
       "1 1 1 1 1 1 6" \
       "6 1 1 1 1 1 1" \
      )

# Test cases
testCases() {
    toScreen=("$@")


    IFS=""
    for c in ${cases[@]}; do
        IFS=" "
        if [[ -z "$toScreen" ]]; then
            splitSum $c > /dev/null
        else 
            echo "bash: [ $c ] -> [ $(splitSum $c) ]"
        fi
    done
}

testCases "true"

start_time=$(date +%s)

# Bash is so slow, do 100,000 then * 10
for ((i = 0; i < 100000; i++)); do
    testCases
done

end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
elapsed_time=$((elapsed_time * 10))
echo "bash: $elapsed_time seconds"
