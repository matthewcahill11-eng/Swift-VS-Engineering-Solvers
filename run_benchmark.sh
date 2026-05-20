#!/bin/bash

echo "=== Running Final Benchmarks (5 runs each, reporting median) ==="
echo

# C++
echo "C++ (g++ -O3):"
for i in {1..7}; do
    ./poisson_solver_cpp 2>/dev/null | grep "Time:" | awk '{print $2}'
done | sort -n | sed -n '4p'

# Fortran
echo "Fortran (gfortran -O3):"
for i in {1..7}; do
    ./poisson_solver_fortran 2>/dev/null | grep "Time:" | awk '{print $2}'
done | sort -n | sed -n '4p'

# Rust
echo "Rust (rustc -O):"
for i in {1..7}; do
    ./poisson_solver_rust 2>/dev/null | grep "Time:" | awk '{print $2}'
done | sort -n | sed -n '4p'

# Julia
echo "Julia (JIT):"
for i in {1..7}; do
    ~/.juliaup/bin/julia poisson_solver.jl 2>/dev/null | grep "Time:" | awk '{print $2}'
done | sort -n | sed -n '4p'

# Swift optimized
echo "Swift optimized (swiftc -O, flat array):"
for i in {1..7}; do
    sudo docker run --rm -v /home/ec2-user:/code swift:5.10 /code/poisson_solver_swift_opt 2>/dev/null | grep "Time:" | awk '{print $2}'
done | sort -n | sed -n '4p'

echo
echo "Getting center values and residuals..."
./poisson_solver_cpp 2>/dev/null | grep -E "Sample|L2"
