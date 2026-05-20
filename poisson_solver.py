#!/usr/bin/env python3
import time
import numpy as np

def jacobi_poisson_solver(n, max_iter):
    """
    Solve 2D Poisson equation using Jacobi iteration
    Boundary conditions: u = 0 on edges
    Source term: f = sin(x) * sin(y)
    """
    # Initialize grid
    u = np.zeros((n, n))
    u_new = np.zeros((n, n))
    f = np.zeros((n, n))

    # Set up source term
    dx = 1.0 / (n - 1)
    for i in range(n):
        for j in range(n):
            x = i * dx
            y = j * dx
            f[i, j] = np.sin(x * np.pi) * np.sin(y * np.pi)

    # Jacobi iteration
    for iteration in range(max_iter):
        for i in range(1, n-1):
            for j in range(1, n-1):
                u_new[i, j] = 0.25 * (u[i+1, j] + u[i-1, j] +
                                       u[i, j+1] + u[i, j-1] +
                                       dx * dx * f[i, j])

        # Swap arrays
        u, u_new = u_new, u

    return u

if __name__ == "__main__":
    n = 500
    max_iter = 500

    print(f"Python Poisson Solver: {n}x{n} grid, {max_iter} iterations")

    start = time.time()
    u = jacobi_poisson_solver(n, max_iter)
    end = time.time()

    print(f"Time: {end - start:.4f} seconds")
    print(f"Sample value at center: {u[n//2, n//2]:.6f}")
