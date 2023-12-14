
program main
    implicit none

    ! Need a custom type to get an "array of arrays".
    type :: type_int_alloc
        integer, dimension(:), allocatable :: data
    end type type_int_alloc

    integer :: i
    integer :: max = 0
    real :: start_time
    real :: end_time

    ! Global so they aren't reallcoated on the stack each invocation.
    type(type_int_alloc) :: cases(11)
    integer, allocatable :: resultLeft(:)
    integer, allocatable :: resultRight(:)

    allocate(cases(1)%data(0))
    allocate(cases(2)%data,  source=[100])
    allocate(cases(3)%data,  source=[99, 99])
    allocate(cases(4)%data,  source=[99, 1, 98])
    allocate(cases(5)%data,  source=[98, 1, 99])
    allocate(cases(6)%data,  source=[1, 2, 3, 0])
    allocate(cases(7)%data,  source=[1, 2, 3, 5])
    allocate(cases(8)%data,  source=[1, 2, 2, 1, 0])
    allocate(cases(9)%data,  source=[10, 11, 12, 16, 17])
    allocate(cases(10)%data, source=[1, 1, 1, 1, 1, 1, 6])
    allocate(cases(11)%data, source=[6, 1, 1, 1, 1, 1, 1])

    do i = 1, size(cases)
        if (max < size(cases(i)%data)) then
            max = size(cases(i)%data)
        end if
    end do
    allocate(resultLeft(max))
    allocate(resultRight(max))
    
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
        integer, dimension(2) :: returnColumnSizes
        character (len=100) :: fmt
        integer :: length
        integer :: i

        ! Process test cases
        do i = 1, size(cases)
            length = size(cases(i)%data)
            call splitSum(cases(i)%data, length, resultLeft, resultRight, returnColumnSizes)
            if (toScreen > 0) then
                if (length == 0) then
                    write(*, "(a)", advance="no") 'Fortran: [] -> ['
                else
                    write(fmt, "('(a,', i0, '(I0,:, '', ''))')") length
                    write(*, fmt, advance="no") 'Fortran: [', cases(i)%data
                    write(*, "(a)", advance="no") '] -> ['
                endif

                if (returnColumnSizes(1) == 0) then
                    write(*, "(a)", advance="no") '[]'
                else
                    write(fmt, "('(a,', i0, '(I0,:, '', ''))')") returnColumnSizes(1)
                    write(*, fmt, advance="no") '[', resultLeft(1:returnColumnSizes(1))
                    write(*, "(a)", advance="no") '],'
                endif

                if (returnColumnSizes(2) == 0) then
                    write(*, "(a)", advance="no") '[]'
                else
                    write(fmt, "('(a,', i0, '(I0,:, '', ''))')") returnColumnSizes(2)
                    write(*, fmt, advance="no") '[', resultRight(1:returnColumnSizes(2))
                    write(*, "(a)", advance="no") ']'
                endif

                write(*, "(a)") ']'

            end if
        end do

    end subroutine testCases

end program main
