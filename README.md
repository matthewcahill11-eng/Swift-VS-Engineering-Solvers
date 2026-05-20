# Swift vs Engineering Solvers: Performance Benchmark

Battle testing Swift versus popular engineering solver languages (A challenge from a friend to see if Apple could even make a better language than everyone else)

Comprehensive benchmark comparing Swift, C++, Rust, Fortran, Julia, and Python for a 2D Poisson CFD solver using Jacobi iteration.

## Quick Results

| Language | Time (s) | vs Python | Notes |
|----------|----------|-----------|-------|
| **C++** (g++ -O3) | 0.17 | 1101x faster | Reference implementation |
| **Swift** (optimized) | 0.19 | 1018x faster | Flat array + UnsafePointer |
| **Fortran** | 0.23 | 808x faster | Classic numerical computing |
| **Rust** | 0.52 | 362x faster | Memory safe + fast |
| **Julia** | 0.62 | 305x faster | High-level + JIT compiled |
| **Swift** (naive) | 1.35 | 140x faster | Array<Array<Double>> |
| **Python** | 188.64 | baseline | Pure Python loops |

## Key Finding: Swift Data Structures Matter

**Swift with proper data structures matches C++ performance!**

- **Naive Swift** (`[[Double]]`): 1.35s
- **Optimized Swift** (flat `[Double]`): 0.19s
- **Speedup: 7.3x** from data structure alone!

### Why the Difference?

**Naive `[[Double]]` (slow):**
- Array of pointers to separate row arrays
- Non-contiguous memory (cache unfriendly)
- Double pointer dereference + double bounds checking
- Compiler cannot vectorize

**Optimized `[Double]` (fast):**
- Single flat buffer (like C++ `vector<double>`)
- Contiguous memory (cache friendly)
- `UnsafePointer` eliminates bounds checking
- Compiler can vectorize

## Problem Description

Solves the 2D Poisson equation using Jacobi iteration:
```
-∇²u = f
```
where `f(x,y) = sin(πx)sin(πy)`

**Configuration:**
- Grid: 500×500
- Iterations: 500
- Boundary conditions: u = 0 on edges

## Files

- `poisson_solver.cpp` - C++ implementation
- `poisson_solver.swift` - Swift naive (Array<Array<Double>>)
- `poisson_solver_optimized.swift` - Swift optimized (flat array)
- `poisson_solver.f90` - Fortran implementation
- `poisson_solver.rs` - Rust implementation
- `poisson_solver.jl` - Julia implementation
- `poisson_solver.py` - Python implementation
- `PHASE_1_2_3_4_RESULTS.md` - Complete audit results
- `benchmark_results.md` - Detailed benchmark analysis

## Running the Benchmarks

### C++
```bash
g++ -O3 -o poisson_solver_cpp poisson_solver.cpp -lm
./poisson_solver_cpp
```

### Swift (requires Docker on Linux)
```bash
# Naive
docker run --rm -v $(pwd):/code swift:5.10 bash -c "cd /code && swiftc -O -o poisson_solver_swift poisson_solver.swift && ./poisson_solver_swift"

# Optimized
docker run --rm -v $(pwd):/code swift:5.10 bash -c "cd /code && swiftc -O -o poisson_solver_swift_opt poisson_solver_optimized.swift && ./poisson_solver_swift_opt"
```

### Fortran
```bash
gfortran -O3 -o poisson_solver_fortran poisson_solver.f90
./poisson_solver_fortran
```

### Rust
```bash
rustc -O -o poisson_solver_rust poisson_solver.rs
./poisson_solver_rust
```

### Julia
```bash
julia poisson_solver.jl
```

### Python
```bash
python3 poisson_solver.py
```

## Correctness Verification

All implementations produce:
- **Center value:** `0.0004995270`
- **L2 residual:** `4.961e-01`

Verified to 6 significant figures.

## Lessons Learned

1. **Data structure choice matters more than language** - Swift's 7.3x speedup proves this
2. **"Idiomatic" code ≠ fast code** for numerical workloads
3. **Swift can match C++** when written with flat buffers and unsafe pointers
4. **Modern compilers are excellent** - manual optimization flags often don't help
5. **Production Swift numerical code** uses flat arrays, not nested arrays

## Credits

Inspired by discussions about Swift's viability for numerical computing and gradient descent implementations.

## License

MIT
