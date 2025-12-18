#!/bin/bash
#
# Compile-only test for uplm80 PL/M-80 compiler tests
# Verifies that all test files compile and assemble without errors
#
# Usage: ./compile_tests.sh [test_name]
#

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$SCRIPT_DIR/build"
PYTHON=${PYTHON:-python3}
UM80=${UM80:-um80}
UL80=${UL80:-ul80}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0

mkdir -p "$BUILD_DIR"

compile_test() {
    local test_name="$1"
    local plm_file="$SCRIPT_DIR/${test_name}.plm"
    local mac_file="$BUILD_DIR/${test_name}.mac"
    local rel_file="$BUILD_DIR/${test_name}.rel"
    local com_file="$BUILD_DIR/${test_name}.com"

    echo -n "Compiling $test_name... "

    if [ ! -f "$plm_file" ]; then
        echo -e "${YELLOW}SKIPPED${NC}"
        return 0
    fi

    # Compile
    if ! $PYTHON -m uplm80.compiler "$plm_file" -o "$mac_file" 2>"$BUILD_DIR/${test_name}_compile.err"; then
        echo -e "${RED}COMPILE FAILED${NC}"
        cat "$BUILD_DIR/${test_name}_compile.err"
        ((FAILED++))
        return 1
    fi

    # Assemble
    if ! $UM80 "$mac_file" -o "$rel_file" 2>"$BUILD_DIR/${test_name}_asm.err"; then
        echo -e "${RED}ASSEMBLE FAILED${NC}"
        cat "$BUILD_DIR/${test_name}_asm.err"
        ((FAILED++))
        return 1
    fi

    # Link
    if ! $UL80 -o "$com_file" "$rel_file" 2>"$BUILD_DIR/${test_name}_link.err"; then
        echo -e "${RED}LINK FAILED${NC}"
        cat "$BUILD_DIR/${test_name}_link.err"
        ((FAILED++))
        return 1
    fi

    local size=$(stat -c%s "$com_file" 2>/dev/null || stat -f%z "$com_file" 2>/dev/null)
    echo -e "${GREEN}OK${NC} ($size bytes)"
    ((PASSED++))
    return 0
}

cd "$PROJECT_DIR"

echo "=========================================="
echo "uplm80 Compile Tests"
echo "=========================================="
echo ""

if [ -n "$1" ]; then
    compile_test "$1"
else
    # Compile all test_*.plm files
    for plm in "$SCRIPT_DIR"/test_*.plm; do
        if [ -f "$plm" ]; then
            test_name=$(basename "$plm" .plm)
            compile_test "$test_name" || true
        fi
    done
fi

echo ""
echo "=========================================="
echo "Results: $PASSED compiled, $FAILED failed"
echo "=========================================="

[ $FAILED -eq 0 ]
