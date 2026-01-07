# PL/M-80 Feature Index

This document indexes all PL/M-80 language features and built-in procedures
from the Intel PL/M-80 Programming Manual, with test coverage status.

## Built-In Procedures

| Procedure | Description | Test File | Status |
|-----------|-------------|-----------|--------|
| INPUT(port) | Read byte from I/O port | - | Not testable (hardware) |
| LOW(expr) | Get low byte of ADDRESS | test_low_high.plm | Tested |
| HIGH(expr) | Get high byte of ADDRESS | test_low_high.plm | Tested |
| DOUBLE(expr) | Zero-extend BYTE to ADDRESS | test_double_builtin.plm | Tested |
| LENGTH(array) | Get number of elements in array | test_all.plm | Tested |
| LAST(array) | Get last valid subscript (LENGTH-1) | test_all.plm | Tested |
| SIZE(var) | Get size in bytes | test_all.plm | Tested |
| SHL(pattern, count) | Shift left | test_byte_shifts.plm, test_var_shift.plm | Tested |
| SHR(pattern, count) | Shift right | test_byte_shifts.plm, test_var_shift.plm | Tested |
| ROL(pattern, count) | Rotate left (BYTE) | test_byte_shifts.plm | Tested |
| ROR(pattern, count) | Rotate right (BYTE) | test_byte_shifts.plm | Tested |
| SCL(pattern, count) | Shift with carry left | test_byte_shifts.plm | Tested |
| SCR(pattern, count) | Shift with carry right | test_byte_shifts.plm | Tested |
| MOVE(count, src, dst) | Copy memory block | test_move_builtin.plm | Tested |
| TIME(delay) | Time delay (100us units) | - | Not testable (timing) |
| DEC(expr) | Decimal adjust (BCD) | test_dec_bcd.plm | Tested |
| CARRY | Get carry flag value | - | Not testable (optimizer) |
| SIGN | Get sign flag value | - | Not testable (optimizer) |
| ZERO | Get zero flag value | - | Not testable (optimizer) |
| PARITY | Get parity flag value | - | Not testable (optimizer) |

## Predeclared Variables

| Variable | Description | Test File | Status |
|----------|-------------|-----------|--------|
| OUTPUT(port) | Write to I/O port | - | Not testable (hardware) |
| MEMORY(addr) | Byte array at end of program | test_all.plm | Tested |
| STACKPTR | Stack pointer register | - | Not testable (dangerous) |

## Data Types

| Feature | Description | Test File | Status |
|---------|-------------|-----------|--------|
| BYTE | 8-bit unsigned integer | (all tests) | Tested |
| ADDRESS | 16-bit unsigned integer | (all tests) | Tested |
| Scalar variables | Single BYTE/ADDRESS value | (all tests) | Tested |
| Arrays | Subscripted variables | test_all.plm | Tested |
| Structures | Named member groups | test_structures.plm | Tested |
| Arrays of structures | DECLARE X(n) STRUCTURE(...) | test_structures.plm | Tested |
| Arrays in structures | Members with dimensions | test_literally.plm | Tested |
| BASED variables | Pointer indirection | test_structures.plm, test_based_proc.plm | Tested |

## Operators

| Operator | Description | Test File | Status |
|----------|-------------|-----------|--------|
| + | Addition | (many tests) | Tested |
| - | Subtraction | (many tests) | Tested |
| * | Multiplication | test_all.plm | Tested |
| / | Division | test_all.plm | Tested |
| MOD | Modulo | test_all.plm | Tested |
| PLUS | Add with carry | test_plus_minus.plm | Tested |
| MINUS | Subtract with borrow | test_plus_minus.plm | Tested |
| AND | Bitwise AND | test_bitwise.plm, test_byte_conditions.plm | Tested |
| OR | Bitwise OR | test_bitwise.plm | Tested |
| XOR | Bitwise XOR | test_bitwise.plm | Tested |
| NOT | Bitwise NOT | test_bitwise.plm | Tested |
| < | Less than | test_addr_compare.plm | Tested |
| > | Greater than | test_addr_compare.plm | Tested |
| <= | Less or equal | test_addr_compare.plm | Tested |
| >= | Greater or equal | test_addr_compare.plm | Tested |
| = | Equal | (many tests) | Tested |
| <> | Not equal | test_addr_compare.plm | Tested |

## Statements

| Statement | Description | Test File | Status |
|-----------|-------------|-----------|--------|
| Assignment (=) | Assign value to variable | (all tests) | Tested |
| Multiple assignment | X, Y = value | test_all.plm | Tested |
| Embedded assignment | X = (Y := value) | test_all.plm | Tested |
| IF-THEN-ELSE | Conditional execution | (many tests) | Tested |
| Simple DO block | DO; ... END; | (many tests) | Tested |
| DO WHILE | While loop | (many tests) | Tested |
| Iterative DO | DO I = start TO end [BY step] | test_djnz_loops.plm | Tested |
| DO CASE | Case/switch statement | test_all.plm | Tested |
| GOTO | Jump to label | test_goto_loops.plm | Tested |
| HALT | Stop execution | - | Not testable (halts) |
| CALL | Call untyped procedure | (all tests) | Tested |
| RETURN | Return from procedure | (all tests) | Tested |

## Declarations

| Feature | Description | Test File | Status |
|---------|-------------|-----------|--------|
| DECLARE scalar | DECLARE X BYTE/ADDRESS | (all tests) | Tested |
| DECLARE array | DECLARE X(n) BYTE/ADDRESS | (many tests) | Tested |
| DECLARE STRUCTURE | Structure type | test_structures.plm | Tested |
| LITERALLY | Compile-time macro | test_literally.plm | Tested |
| LABEL | Explicit label declaration | test_label_decl.plm | Tested |
| DATA | Initialize with values | test_data_decl.plm | Tested |
| INITIAL | Initialize variables | test_all.plm, test_data_decl.plm | Tested |
| AT | Locate at specific address | test_external.plm | Tested |
| BASED | Pointer-based variable | test_structures.plm | Tested |

## Procedure Features

| Feature | Description | Test File | Status |
|---------|-------------|-----------|--------|
| Typed procedures | PROCEDURE BYTE/ADDRESS | test_implicit_calls.plm | Tested |
| Untyped procedures | PROCEDURE (no return) | (all tests) | Tested |
| Parameters | PROCEDURE(A, B) | (all tests) | Tested |
| Implicit calls | X = FUNC (no parens) | test_implicit_calls.plm | Tested |
| PUBLIC | Export symbol | test_external.plm | Tested |
| EXTERNAL | Import symbol | test_external.plm | Tested |
| INTERRUPT | Interrupt handler | test_interrupt.plm | Tested |
| REENTRANT | Re-entrant procedure | test_reentrant.plm | Tested |

## Other Features

| Feature | Description | Test File | Status |
|---------|-------------|-----------|--------|
| Location operator (.) | Get address of variable | test_structures.plm | Tested |
| String constants | 'text' | (many tests) | Tested |
| Numeric constants | Decimal, hex (0FFH), binary (10B) | (many tests) | Tested |
| Block structure | Nested scopes | test_reentrant.plm | Tested |
| Conditional compile | $IF/$ELSE/$ENDIF | test_conditional_compile.plm | Tested |

## Summary

### All Testable Features Covered
All testable PL/M-80 features now have tests.

### Not Testable
- INPUT/OUTPUT - Requires hardware I/O ports
- TIME - Timing-dependent, can't verify in emulator
- CARRY/SIGN/ZERO/PARITY - Flag state unpredictable due to optimization
- STACKPTR - Dangerous to manipulate
- HALT - Would stop the test

### Test Coverage: 100% of testable features (22 tests passing)
