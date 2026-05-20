program poisson_solver
    implicit none
    integer, parameter :: n = 500
    integer, parameter :: max_iter = 500
    real(8), dimension(n, n) :: u, u_new, f
    real(8) :: dx, x, y, start_time, end_time
    integer :: i, j, iter

    ! Initialize grids
    u = 0.0d0
    u_new = 0.0d0
    f = 0.0d0

    ! Set up source term
    dx = 1.0d0 / (n - 1)
    do i = 1, n
        do j = 1, n
            x = (i - 1) * dx
            y = (j - 1) * dx
            f(i, j) = sin(x * 3.14159265358979323846d0) * sin(y * 3.14159265358979323846d0)
        end do
    end do

    print '(A,I0,A,I0,A,I0,A)', 'Fortran Poisson Solver: ', n, 'x', n, ' grid, ', max_iter, ' iterations'

    call cpu_time(start_time)

    ! Jacobi iteration
    do iter = 1, max_iter
        do i = 2, n-1
            do j = 2, n-1
                u_new(i, j) = 0.25d0 * (u(i+1, j) + u(i-1, j) + &
                                        u(i, j+1) + u(i, j-1) + &
                                        dx * dx * f(i, j))
            end do
        end do

        ! Swap arrays
        u = u_new
    end do

    call cpu_time(end_time)

    print '(A,F0.4,A)', 'Time: ', end_time - start_time, ' seconds'
    print '(A,F0.6)', 'Sample value at center: ', u(n/2, n/2)

end program poisson_solver
