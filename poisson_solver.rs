use std::f64::consts::PI;
use std::time::Instant;

fn jacobi_poisson_solver(n: usize, max_iter: usize) -> Vec<Vec<f64>> {
    // Initialize grids
    let mut u = vec![vec![0.0; n]; n];
    let mut u_new = vec![vec![0.0; n]; n];
    let mut f = vec![vec![0.0; n]; n];

    // Set up source term
    let dx = 1.0 / (n - 1) as f64;
    for i in 0..n {
        for j in 0..n {
            let x = i as f64 * dx;
            let y = j as f64 * dx;
            f[i][j] = (x * PI).sin() * (y * PI).sin();
        }
    }

    // Jacobi iteration
    for _ in 0..max_iter {
        for i in 1..n-1 {
            for j in 1..n-1 {
                u_new[i][j] = 0.25 * (u[i+1][j] + u[i-1][j] +
                                       u[i][j+1] + u[i][j-1] +
                                       dx * dx * f[i][j]);
            }
        }

        // Swap arrays
        std::mem::swap(&mut u, &mut u_new);
    }

    u
}

fn main() {
    let n = 500;
    let max_iter = 500;

    println!("Rust Poisson Solver: {}x{} grid, {} iterations", n, n, max_iter);

    let start = Instant::now();
    let u = jacobi_poisson_solver(n, max_iter);
    let elapsed = start.elapsed();

    println!("Time: {:.4} seconds", elapsed.as_secs_f64());
    println!("Sample value at center: {:.6}", u[n/2][n/2]);
}
