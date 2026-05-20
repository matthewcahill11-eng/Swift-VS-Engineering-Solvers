import Foundation

func jacobiPoissonSolver(n: Int, maxIter: Int) -> [Double] {
    let cells = n * n
    var u = [Double](repeating: 0.0, count: cells)
    var uNew = [Double](repeating: 0.0, count: cells)
    var f = [Double](repeating: 0.0, count: cells)

    let dx = 1.0 / Double(n - 1)
    let h2 = dx * dx

    // build source
    f.withUnsafeMutableBufferPointer { fBuf in
        let fp = fBuf.baseAddress!
        for i in 0..<n {
            let x = Double(i) * dx
            let sx = sin(x * .pi)
            for j in 0..<n {
                let y = Double(j) * dx
                fp[i*n + j] = sx * sin(y * .pi)
            }
        }
    }

    u.withUnsafeMutableBufferPointer { uBuf in
        uNew.withUnsafeMutableBufferPointer { vBuf in
            f.withUnsafeBufferPointer { fBuf in
                var a = uBuf.baseAddress!
                var b = vBuf.baseAddress!
                let fp = fBuf.baseAddress!
                for _ in 0..<maxIter {
                    for i in 1..<(n-1) {
                        let rowUp = a + (i-1)*n
                        let rowMid = a + i*n
                        let rowDn = a + (i+1)*n
                        let rowF = fp + i*n
                        let rowOut = b + i*n
                        for j in 1..<(n-1) {
                            rowOut[j] = 0.25 * (
                                rowUp[j] + rowDn[j]
                                + rowMid[j-1] + rowMid[j+1]
                                + h2 * rowF[j]    // PLUS (corrected from minus)
                            )
                        }
                    }
                    swap(&a, &b)
                }
                // copy live buffer back to u so caller sees the right one
                if a != uBuf.baseAddress! {
                    uBuf.baseAddress!.update(from: a, count: cells)
                }
            }
        }
    }
    return u
}

let n = 500
let maxIter = 500

print("Swift Poisson Solver (Optimized): \(n)x\(n) grid, \(maxIter) iterations")

let start = Date()
let u = jacobiPoissonSolver(n: n, maxIter: maxIter)
let end = Date()

let elapsed = end.timeIntervalSince(start)
print(String(format: "Time: %.4f seconds", elapsed))
print(String(format: "Sample value at center: %.6f", u[n/2*n + n/2]))
