# Swift vs Engineering Solvers: Final Summary

**Date Completed:** May 20, 2026  
**Repository:** https://github.com/matthewcahill11-eng/Swift-VS-Engineering-Solvers

---

## Project Motivation

A friend challenged whether Apple's Swift could compete with established engineering languages for numerical computing. This benchmark provides an objective answer.

---

## What We Tested

**Problem:** 2D Poisson CFD solver using Jacobi iteration
- Grid: 500×500 cells
- Iterations: 500
- Equation: `-∇²u = sin(πx)sin(πy)`

**Languages:** C++ (g++/clang++), Swift (naive/optimized), Fortran, Rust, Julia, Python

---

## Results

| Language | Time (s) | vs Python | vs C++ |
|----------|----------|-----------|--------|
| C++ (g++) | 0.17 | 1101x | 1.00x |
| **Swift (optimized)** | **0.19** | **1018x** | **1.12x** |
| C++ (clang++) | 0.22 | 870x | 1.29x |
| Fortran | 0.23 | 808x | 1.35x |
| Rust | 0.52 | 362x | 3.06x |
| Julia | 0.62 | 305x | 3.65x |
| Swift (naive) | 1.35 | 140x | 7.94x |
| Python | 188.64 | 1.00x | 1109x |

**All implementations verified correct** - produce identical results to 6 significant figures.

---

## The Critical Discovery

### Swift's 7.3x Performance Gap Was Entirely Data Structure Choice

**Naive Swift:**
```swift
var u = [[Double]](repeating: [Double](repeating: 0.0, count: n), count: n)
// Result: 1.35 seconds
```

**Optimized Swift:**
```swift
var u = [Double](repeating: 0.0, count: n*n)
// Access: u[i*n + j]
// Result: 0.19 seconds
```

### Why the Difference?

| Aspect | `[[Double]]` (slow) | `[Double]` (fast) |
|--------|-------------------|------------------|
| Memory layout | Non-contiguous | Contiguous |
| Pointer dereference | 2x per access | 1x per access |
| Bounds checking | 2x per access | 1x per access |
| Cache behavior | Cache-unfriendly | Cache-friendly |
| Vectorization | Impossible | Compiler can vectorize |

---

## What This Actually Proves

### ✅ What We Proved
1. **Swift isn't inherently slow** - it CAN match C++ (0.19s vs 0.17s)
2. **Data structures matter more than language** - 7.3x difference from this alone
3. **Fortran still relevant** - after 60+ years, competitive with modern C++
4. **Rust trades some speed for safety** - still 362x faster than Python
5. **Julia bridges the gap** - high-level syntax with compiled-language speed

### ❌ What We Didn't Prove
1. **Swift isn't "as fast as C++"** - only when you fight Swift's idioms
2. **Swift doesn't have an advantage** - it has no disadvantage when written carefully
3. **Idiomatic Swift is fast** - actually, idiomatic Swift is 7.3x slower

---

## The Honest Conclusion

### For Swift Advocates
Swift **can** match C++ for numerical computing, but you must:
- Use flat `[Double]` arrays, not `[[Double]]`
- Use `withUnsafeMutableBufferPointer` in hot loops
- Index manually with `i*n + j`
- Essentially write C++ in Swift syntax

### For Swift Skeptics
Swift isn't fundamentally slow - the overhead is from safety features you can bypass. When written like C++, it performs like C++.

### For Engineers
**Pick your language by ecosystem, not micro-benchmarks:**
- **C++/Fortran:** Production HPC, maximum performance
- **Rust:** When memory safety matters
- **Julia:** Research/prototyping (best language-ergonomics-to-performance ratio)
- **Swift:** If already in Apple ecosystem
- **Python:** With NumPy/libraries, never explicit loops

---

## Technical Insights

### 1. The Sign Bug
All initial implementations had wrong sign in Jacobi formula:
- **Wrong:** `0.25 * (neighbors - h²*f)`
- **Correct:** `0.25 * (neighbors + h²*f)`

Fixed across all languages during Phase 1 correctness audit.

### 2. Compiler Optimizations Are Excellent
- C++: Adding `-march=native -ffast-math` didn't improve beyond `-O3`
- Julia: Manual `@inbounds @simd` made it **slower** (4.5s vs 1.0s)
- Modern compilers already optimize aggressively

### 3. Production Swift Numerical Code
Fast Swift numerical libraries (Accelerate wrappers, etc.) all use this pattern:
- Flat contiguous buffers
- Unsafe pointers in hot loops
- Manual indexing
- Not the "Swift" way, but the fast way

---

## Repository Contents

### Implementation Files
- `poisson_solver.cpp` - C++ reference implementation
- `poisson_solver.swift` - Naive Swift with `[[Double]]`
- `poisson_solver_optimized.swift` - Fast Swift with flat arrays
- `poisson_solver.f90` - Fortran implementation
- `poisson_solver.rs` - Rust implementation
- `poisson_solver.jl` - Julia implementation
- `poisson_solver.py` - Python implementation

### Documentation
- `README.md` - Quick start guide
- `benchmark_results.md` - Detailed performance analysis
- `PHASE_1_2_3_4_RESULTS.md` - Complete development audit
- `CONVERSATION_SUMMARY.md` - Development timeline
- `FINAL_SUMMARY.md` - This document

### Scripts
- `run_benchmark.sh` - Run all benchmarks
- `final_report.sh` - Generate comparison report

---

## How to Use This Research

### For Blog Posts / Papers
**Honest framing:**
> "We demonstrate that data structure choice impacts performance more than language choice. Swift with flat arrays matches C++ (0.19s vs 0.17s), while Swift with nested arrays is 7.3x slower. This proves Swift can achieve C++-level performance for numerical computing when memory layout is carefully controlled."

**Misleading framing to avoid:**
> "Swift is as fast as C++ for numerical computing" (implies idiomatic Swift)

### For Tweets
See tweet options in previous conversation. Recommend leading with the data structure insight rather than language comparison.

### For Portfolio
**Key takeaway:** Demonstrates understanding that:
1. Performance is about memory layout, not just language syntax
2. Modern languages can match C++ with proper technique
3. "Best practices" aren't always performant practices
4. Benchmarking requires correctness verification, not just timing

---

## Future Work (Not Pursued)

Potential extensions:
1. **GPU implementations** - Compare Metal (Swift) vs CUDA (C++)
2. **Multigrid solver** - Test on more complex algorithm
3. **3D problems** - See if conclusions hold with larger memory footprint
4. **Memory profiling** - Measure cache miss rates
5. **Production Navier-Stokes** - Test on real CFD (see cylinder-flow-re40 attempt)

---

## Lessons for Future Numerical Swift

If you want fast Swift numerical code:

### ✅ Do
- Use flat `[Double]` with manual indexing
- Use `withUnsafeMutableBufferPointer` in hot loops
- Cache row pointers: `let rowPtr = ptr + i*n`
- Profile with Instruments to verify vectorization
- Look at how Accelerate.framework is implemented

### ❌ Don't
- Use `[[Double]]` for matrices/grids
- Trust that "clean" code is fast code
- Assume bounds checking is free
- Use nested structs for numeric data
- Fight the language - if you need C++ performance, just use C++

---

## Final Verdict

**Question:** "Can Swift match C++ for engineering solvers?"

**Answer:** Yes, but with caveats.

Swift can match C++ when written with C++-style data structures. This makes it a viable choice if you're already in the Apple ecosystem, but it doesn't make it a better choice than C++, Fortran, or Julia for numerical computing specifically.

The 7.3x speedup from a single data structure change is the real story - it proves that **how you structure data matters more than what language you use**.

---

## Acknowledgments

- Inspired by discussions about Swift's viability for numerical computing
- Thanks to the friend who issued the challenge
- Built and benchmarked using AWS EC2 (Amazon Linux 2023)
- Claude Code assisted with development and analysis

---

**Status:** ✅ Complete and published  
**License:** MIT  
**Contact:** Matthew Cahill (https://github.com/matthewcahill11-eng)
