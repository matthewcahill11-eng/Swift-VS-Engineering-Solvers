#include <iostream>
#include <vector>
#include <cmath>
#include <chrono>
#include <iomanip>

std::vector<std::vector<double>> jacobi_poisson_solver(int n, int max_iter) {
    // Initialize grids
    std::vector<std::vector<double>> u(n, std::vector<double>(n, 0.0));
    std::vector<std::vector<double>> u_new(n, std::vector<double>(n, 0.0));
    std::vector<std::vector<double>> f(n, std::vector<double>(n, 0.0));

    // Set up source term
    double dx = 1.0 / (n - 1);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            double x = i * dx;
            double y = j * dx;
            f[i][j] = sin(x * M_PI) * sin(y * M_PI);
        }
    }

    // Jacobi iteration
    for (int iter = 0; iter < max_iter; iter++) {
        for (int i = 1; i < n-1; i++) {
            for (int j = 1; j < n-1; j++) {
                u_new[i][j] = 0.25 * (u[i+1][j] + u[i-1][j] +
                                       u[i][j+1] + u[i][j-1] +
                                       dx * dx * f[i][j]);
            }
        }

        // Swap arrays
        std::swap(u, u_new);
    }

    return u;
}

int main() {
    int n = 500;
    int max_iter = 500;

    std::cout << "C++ Poisson Solver: " << n << "x" << n << " grid, "
              << max_iter << " iterations" << std::endl;

    auto start = std::chrono::high_resolution_clock::now();
    auto u = jacobi_poisson_solver(n, max_iter);
    auto end = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> elapsed = end - start;

    // Reconstruct f and compute L2 residual
    double dx = 1.0 / (n - 1);
    std::vector<std::vector<double>> f(n, std::vector<double>(n, 0.0));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            double x = i * dx;
            double y = j * dx;
            f[i][j] = sin(x * M_PI) * sin(y * M_PI);
        }
    }

    double residual_sum = 0.0;
    int count = 0;
    for (int i = 1; i < n-1; i++) {
        for (int j = 1; j < n-1; j++) {
            double laplacian = (u[i+1][j] + u[i-1][j] + u[i][j+1] + u[i][j-1] - 4*u[i][j]) / (dx * dx);
            double residual = laplacian + f[i][j];
            residual_sum += residual * residual;
            count++;
        }
    }
    double l2_residual = std::sqrt(residual_sum / count);

    std::cout << std::fixed << std::setprecision(4);
    std::cout << "Time: " << elapsed.count() << " seconds" << std::endl;
    std::cout << std::setprecision(10);
    std::cout << "Sample value at center: " << u[n/2][n/2] << std::endl;
    std::cout << std::scientific << std::setprecision(10);
    std::cout << "L2 residual: " << l2_residual << std::endl;

    return 0;
}
