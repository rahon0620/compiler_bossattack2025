#!/bin/bash

# Check for help option
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [test_number]"
    echo "  test_number: Optional test case number (e.g., 1, 2, 3...)"
    echo "  If no number is provided, all tests will be run"
    echo "Examples:"
    echo "  $0        # Run all tests"
    echo "  $0 1      # Run only test case 1"
    echo "  $0 10     # Run only test case 10"
    exit 0
fi

# Execute compilation script
echo "Compiling program..."
if ! ./compile.sh; then
    echo "Compilation failed!"
    exit 1
fi

# Double check if the executable was created
if [ ! -f "build/main" ]; then
    echo "Compilation failed! Executable not found."
    exit 1
fi

# Check if specific test number is provided
if [ $# -eq 1 ]; then
    test_number="$1"
    if ! echo "$test_number" | grep -qE '^[0-9]+$'; then
        echo "Error: Test number must be a positive integer"
        exit 1
    fi
    echo "Compilation successful, running test case $test_number..."
    
    # Run specific test
    input_file="testcase/${test_number}.in"
    output_file="testcase/${test_number}.out"
    
    if [ ! -f "$input_file" ]; then
        echo "Error: Test case $test_number not found (missing $input_file)"
        exit 1
    fi
    
    if [ ! -f "$output_file" ]; then
        echo "Error: Expected output file not found (missing $output_file)"
        exit 1
    fi
    
    # Define colors
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color
    
    echo
    
    # Execute program and get output
    actual_output=$(./build/main < "$input_file" 2>/dev/null)
    expected_output=$(cat "$output_file")
    
    # Compare output
    if [ "$actual_output" = "$expected_output" ]; then
        echo -e "${test_number}: ${GREEN}PASS${NC}"
        exit 0
    else
        echo -e "${test_number}: ${RED}FAIL${NC}"
        echo "Expected output:"
        echo "$expected_output"
        echo "Actual output:"
        echo "$actual_output"
        echo "Difference:"
        echo "$expected_output" > /tmp/expected_$test_number
        echo "$actual_output" > /tmp/actual_$test_number
        diff /tmp/expected_$test_number /tmp/actual_$test_number
        rm -f /tmp/expected_$test_number /tmp/actual_$test_number
        exit 1
    fi
else
    echo "Compilation successful, starting tests..."
fi

echo

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Statistics variables
total_tests=0
passed_tests=0

# Iterate through all .in files
for input_file in testcase/*.in; do
    # Extract test number
    test_name=$(basename "$input_file" .in)
    output_file="testcase/${test_name}.out"
    
    # Check if corresponding .out file exists
    if [ ! -f "$output_file" ]; then
        echo "Warning: Cannot find corresponding output file $output_file"
        continue
    fi
    
    total_tests=$((total_tests + 1))
    
    # Execute program and get output
    actual_output=$(./build/main < "$input_file" 2>/dev/null)
    expected_output=$(cat "$output_file")
    
    # Compare output
    if [ "$actual_output" = "$expected_output" ]; then
        echo -e "${test_name}: ${GREEN}PASS${NC}"
        passed_tests=$((passed_tests + 1))
    else
        echo -e "${test_name}: ${RED}FAIL${NC}"
        echo "Expected output:"
        echo "$expected_output"
        echo "Actual output:"
        echo "$actual_output"
        echo "Difference:"
        echo "$expected_output" > /tmp/expected_$test_name
        echo "$actual_output" > /tmp/actual_$test_name
        diff /tmp/expected_$test_name /tmp/actual_$test_name
        rm -f /tmp/expected_$test_name /tmp/actual_$test_name
        echo "----------------------------------------"
    fi
done

echo
echo "Test results: $passed_tests/$total_tests passed"

if [ $passed_tests -eq $total_tests ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed${NC}"
    exit 1
fi

