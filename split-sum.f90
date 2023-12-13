
program main
    implicit none

    integer, parameter :: max_test_cases = 11, max_nums = 8
    integer, dimension(max_test_cases,max_nums) :: test_cases
    integer :: i
    real :: start_time
    real :: end_time

    ! Global so they aren't reallcoated on the stack each invocation.
    test_cases = reshape(&
         (/0,   0,   0,   0,   0,   0,   0,   0 ,&
           1, 100,   0,   0,   0,   0,   0,   0 ,&
           2,  99,  99,   0,   0,   0,   0,   0 ,&
           3,  98,   1,  99,   0,   0,   0,   0 ,&
           3,  99,   1,  98,   0,   0,   0,   0 ,&
           4,   1,   2,   3,   0,   0,   0,   0 ,&
           4,   1,   2,   3,   5,   0,   0,   0 ,&
           5,   1,   2,   2,   1,   0,   0,   0 ,&
           5,  10,  11,  12,  16,  17,   0,   0 ,&
           7,   1,   1,   1,   1,   1,   1,   6 ,&
           7,   6,   1,   1,   1,   1,   1,   1 /), shape(test_cases), order=(/2,1/))


    call testCases(1)

    call cpu_time(start_time)
    do i = 1, 1000000
        call testCases(0)
    end do
    call cpu_time(end_time)
    write(*,"('Fortran: ', F5.3, ' seconds.')") end_time - start_time

contains

    subroutine splitSum(nums, numsSize, resultLeft, resultRight, returnColumnSizes)
        integer, intent(in) :: nums(:)
        integer, intent(in) :: numsSize
        integer, intent(out) :: resultLeft(:)
        integer, intent(out) :: resultRight(:)
        integer, dimension(2), intent(out) :: returnColumnSizes

        ! Local variables
        integer :: totalLeft, totalRight, left, right

        left = 1
        right = numsSize
        totalLeft = 0
        totalRight = 0

        if (numsSize < 2) then
            returnColumnSizes(1) = 0
            returnColumnSizes(2) = 0
            return
        endif 

        ! Compute the sums
        do while (left /= right)
            if (totalLeft <= totalRight) then
                totalLeft = totalLeft + nums(left)
                left = left + 1
            else
                totalRight = totalRight + nums(right)
                right = right - 1
            end if
        end do

        ! Check for split
        if (totalLeft + nums(left) == totalRight) then
            returnColumnSizes(1) = left
            returnColumnSizes(2) = numsSize - right
            resultLeft = nums(1:left)
            resultRight = nums(right + 1:numsSize)
        elseif (totalLeft == totalRight + nums(right)) then
            returnColumnSizes(1) = left - 1
            returnColumnSizes(2) = numsSize - right + 1
            resultLeft = nums(1:left-1)
            resultRight = nums(right:numsSize)
        else
            returnColumnSizes(1) = 0
            returnColumnSizes(2) = 0
        end if

    end subroutine splitSum

    ! Test cases
    subroutine testCases(toScreen)
        integer, intent(in) :: toScreen
        integer, dimension(max_nums) :: resultLeft
        integer, dimension(max_nums) :: resultRight
        integer, dimension(2) :: returnColumnSizes
        character (len=100) :: fmt
        integer :: length
        integer :: i

        ! Process test test_cases
        do i = 1, max_test_cases
            length = test_cases(i, 1)
            call splitSum(test_cases(i,2:), length, resultLeft, resultRight, returnColumnSizes)
            if (toScreen > 0) then
                if (length == 0) then
                    write(*, "('Fortran: [] -> [')", advance="no")
                else
                    write(fmt, "('(''Fortran: ['', ',i0,'(I0:, '', ''))')") length
!            print *, "Length: ", length, " Format: ", fmt
                    write(*, fmt, advance="no") test_cases(i,2:length)
                    write(*, "('] -> [')", advance="no")
                endif

                if (returnColumnSizes(1) == 0) then
                    write(*, "('[],')", advance="no")
                else
                    write(*, "('[')", advance="no")
                    write(fmt, "('(', i0, '(I0,:, '', ''))')"  ) returnColumnSizes(1)
                    write(*, fmt, advance="no") resultLeft(1:returnColumnSizes(1))
                    write(*, "(']')", advance="no")
                endif

                if (returnColumnSizes(2) == 0) then
                    write(*, "('[]')", advance="no")
                else
                    write(*, "('[')", advance="no")
                    write(fmt, "('(', i0, '(I0,:, '', ''))')"  ) returnColumnSizes(2)
                    write(*, fmt, advance="no") resultRight(1:returnColumnSizes(2))
                    write(*, "(']')", advance="no")
                endif

                write(*,"(']')")

            end if
        end do

    end subroutine testCases

end program main
