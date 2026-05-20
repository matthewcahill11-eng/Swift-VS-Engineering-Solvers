using Printf

function jacobi_poisson_solver(n::Int, max_iter::Int)
    # Initialize grids
    u = zeros(Float64, n, n)
    u_new = zeros(Float64, n, n)
    f = zeros(Float64, n, n)

    # Set up source term
    dx = 1.0 / (n - 1)
    for i in 1:n
        for j in 1:n
            x = (i - 1) * dx
            y = (j - 1) * dx
            f[i, j] = sin(x * π) * sin(y * π)
        end
    end

    # Jacobi iteration
    for iter in 1:max_iter
        for i in 2:n-1
            for j in 2:n-1
                u_new[i, j] = 0.25 * (u[i+1, j] + u[i-1, j] +
                                       u[i, j+1] + u[i, j-1] +
                                       dx * dx * f[i, j])
            end
        end

        # Swap arrays
        u, u_new = u_new, u
    end

    return u
end

n = 500
max_iter = 500

println("Julia Poisson Solver: $(n)x$(n) grid, $(max_iter) iterations")

# Warm-up run (Julia JIT compiles on first run)
jacobi_poisson_solver(10, 10)

start = time()
u = jacobi_poisson_solver(n, max_iter)
elapsed = time() - start

@printf("Time: %.4f seconds\n", elapsed)
@printf("Sample value at center: %.6f\n", u[div(n, 2), div(n, 2)])
