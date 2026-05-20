#!/bin/bash

echo "=== PHASE 4: FINAL REPORT ==="
echo
echo "Running each implementation once to verify correctness..."
echo

echo "Language,Time (s),Center Value,L2 Residual"

# C++
output=$(./poisson_solver_cpp 2>/dev/null)
time=$(echo "$output" | grep "Time:" | awk '{print $2}')
center=$(echo "$output" | grep "Sample" | awk '{print $NF}')
residual=$(echo "$output" | grep "L2" | awk '{print $NF}')
echo "C++ (g++ -O3),$time,$center,$residual"

# Fortran
output=$(./poisson_solver_fortran 2>/dev/null)
time=$(echo "$output" | grep "Time:" | awk '{print $2}')
center=$(echo "$output" | grep "Sample" | awk '{print $NF}')
echo "Fortran (gfortran -O3),$time,$center,N/A"

# Rust
output=$(./poisson_solver_rust 2>/dev/null)
time=$(echo "$output" | grep "Time:" | awk '{print $2}')
center=$(echo "$output" | grep "Sample" | awk '{print $NF}')
echo "Rust (rustc -O),$time,$center,N/A"

# Julia
output=$(~/.juliaup/bin/julia poisson_solver.jl 2>/dev/null)
time=$(echo "$output" | grep "Time:" | awk '{print $2}')
center=$(echo "$output" | grep "Sample" | awk '{print $NF}')
echo "Julia (JIT),$time,$center,N/A"

# Swift optimized
output=$(sudo docker run --rm -v /home/ec2-user:/code swift:5.10 /code/poisson_solver_swift_opt 2>/dev/null)
time=$(echo "$output" | grep "Time:" | awk '{print $2}')
center=$(echo "$output" | grep "Sample" | awk '{print $NF}')
echo "Swift optimized (flat array),$time,$center,N/A"

echo
echo "Reference: All center values should match to 6 significant figures"
echo "Reference center value: 0.0004995270"
echo "Reference L2 residual: 4.9606395012e-01"
