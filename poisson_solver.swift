import Foundation

func jacobiPoissonSolver(n: Int, maxIter: Int) -> [[Double]] {
    // Initialize grids
    var u = Array(repeating: Array(repeating: 0.0, count: n), count: n)
    var uNew = Array(repeating: Array(repeating: 0.0, count: n), count: n)
    var f = Array(repeating: Array(repeating: 0.0, count: n), count: n)

    // Set up source term
    let dx = 1.0 / Double(n - 1)
    for i in 0..<n {
        for j in 0..<n {
            let x = Double(i) * dx
            let y = Double(j) * dx
            f[i][j] = sin(x * .pi) * sin(y * .pi)
        }
    }

    // Jacobi iteration
    for _ in 0..<maxIter {
        for i in 1..<(n-1) {
            for j in 1..<(n-1) {
                uNew[i][j] = 0.25 * (u[i+1][j] + u[i-1][j] +
                                      u[i][j+1] + u[i][j-1] +
                                      dx * dx * f[i][j])
            }
        }

        // Swap arrays
        swap(&u, &uNew)
    }

    return u
}

let n = 500
let maxIter = 500

print("Swift Poisson Solver: \(n)x\(n) grid, \(maxIter) iterations")

let start = Date()
let u = jacobiPoissonSolver(n: n, maxIter: maxIter)
let end = Date()

let elapsed = end.timeIntervalSince(start)
print(String(format: "Time: %.4f seconds", elapsed))
print(String(format: "Sample value at center: %.6f", u[n/2][n/2]))
