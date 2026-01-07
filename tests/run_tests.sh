#!/bin/bash
#
# Test runner for uplm80 PL/M-80 compiler tests
#
# Usage: ./run_tests.sh [test_name]
#   Without arguments: runs all tests
#   With argument: runs only the specified test (without .plm extension)
#
# Example:
#   ./run_tests.sh                    # Run all tests
#   ./run_tests.sh test_byte_shifts   # Run only byte shifts test
#

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$SCRIPT_DIR/build"
PYTHON=${PYTHON:-python3}
UM80=${UM80:-um80}
UL80=${UL80:-ul80}
CPMEMU=${CPMEMU:-$HOME/src/cpmemu/src/cpmemu}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASSED=0
FAILED=0
SKIPPED=0

# Create build directory
mkdir -p "$BUILD_DIR"

# Function to get test-specific compiler options
get_compiler_options() {
    local test_name="$1"
    case "$test_name" in
        test_conditional_compile)
            echo "-D TEST_DEFINED"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Function to compile and run a single test
run_test() {
    local test_name="$1"
    local plm_file="$SCRIPT_DIR/${test_name}.plm"
    local expected_file="$SCRIPT_DIR/${test_name}_expected.txt"
    local mac_file="$BUILD_DIR/${test_name}.mac"
    local rel_file="$BUILD_DIR/${test_name}.rel"
    local com_file="$BUILD_DIR/${test_name}.com"
    local output_file="$BUILD_DIR/${test_name}_output.txt"
    local extra_opts=$(get_compiler_options "$test_name")

    echo -n "Testing $test_name... "

    # Check if test file exists
    if [ ! -f "$plm_file" ]; then
        echo -e "${YELLOW}SKIPPED${NC} (no .plm file)"
        ((SKIPPED++))
        return 0
    fi

    # Check if expected output exists
    if [ ! -f "$expected_file" ]; then
        echo -e "${YELLOW}SKIPPED${NC} (no expected output file)"
        ((SKIPPED++))
        return 0
    fi

    # Compile PL/M to assembly (with any test-specific options)
    if ! $PYTHON -m uplm80.compiler $extra_opts "$plm_file" -o "$mac_file" 2>"$BUILD_DIR/${test_name}_compile.err"; then
        echo -e "${RED}FAILED${NC} (compilation error)"
        cat "$BUILD_DIR/${test_name}_compile.err"
        ((FAILED++))
        return 1
    fi

    # Assemble to relocatable
    if ! $UM80 "$mac_file" -o "$rel_file" 2>"$BUILD_DIR/${test_name}_asm.err"; then
        echo -e "${RED}FAILED${NC} (assembly error)"
        cat "$BUILD_DIR/${test_name}_asm.err"
        ((FAILED++))
        return 1
    fi

    # Link to COM file
    if ! $UL80 -o "$com_file" "$rel_file" 2>"$BUILD_DIR/${test_name}_link.err"; then
        echo -e "${RED}FAILED${NC} (link error)"
        cat "$BUILD_DIR/${test_name}_link.err"
        ((FAILED++))
        return 1
    fi

    # Run with CP/M emulator
    if ! $CPMEMU "$com_file" > "$output_file" 2>"$BUILD_DIR/${test_name}_run.err"; then
        echo -e "${RED}FAILED${NC} (runtime error)"
        cat "$BUILD_DIR/${test_name}_run.err"
        ((FAILED++))
        return 1
    fi

    # Strip CR from CP/M output for comparison
    tr -d '\r' < "$output_file" > "$output_file.tmp" && mv "$output_file.tmp" "$output_file"

    # Compare output with expected
    if diff -q "$output_file" "$expected_file" > /dev/null 2>&1; then
        echo -e "${GREEN}PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}FAILED${NC} (output mismatch)"
        echo "--- Expected ---"
        head -20 "$expected_file"
        echo "--- Got ---"
        head -20 "$output_file"
        echo "--- Diff ---"
        diff "$expected_file" "$output_file" | head -30
        ((FAILED++))
        return 1
    fi
}

# Main
cd "$PROJECT_DIR"

echo "=========================================="
echo "uplm80 Compiler Test Suite"
echo "=========================================="
echo ""

# Check tools
echo "Checking tools..."
if ! command -v $PYTHON &> /dev/null; then
    echo "Error: $PYTHON not found"
    exit 1
fi
if ! command -v $UM80 &> /dev/null; then
    echo "Error: $UM80 not found"
    exit 1
fi
if ! command -v $UL80 &> /dev/null; then
    echo "Error: $UL80 not found"
    exit 1
fi
if [ ! -x "$CPMEMU" ]; then
    echo "Error: $CPMEMU not found or not executable"
    exit 1
fi
echo "Tools OK"
echo ""

if [ -n "$1" ]; then
    # Run specific test
    run_test "$1"
else
    # Run all tests with expected output files
    for expected in "$SCRIPT_DIR"/*_expected.txt; do
        if [ -f "$expected" ]; then
            test_name=$(basename "$expected" _expected.txt)
            run_test "$test_name" || true
        fi
    done
fi

echo ""
echo "=========================================="
echo "Results: $PASSED passed, $FAILED failed, $SKIPPED skipped"
echo "=========================================="

if [ $FAILED -gt 0 ]; then
    exit 1
fi
exit 0
