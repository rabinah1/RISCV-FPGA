/* Edge cases and boundary conditions test
 * Tests: Max/min int values, boundary shifts, overflow behavior, zero operations
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

int32_t main(void)
{
    int32_t result;
    /* Test 1: Zero addition */
    int32_t a = 0;
    int32_t b = 0;
    uint32_t c = 0;
    uint32_t d = 0;
    result = a + b;

    if (result != 0) return 1;

    /* Test 2: Adding to zero */
    a = 0;
    b = 42;
    result = a + b;

    if (result != 42) return 2;

    /* Test 3: Zero multiplication (implicit via shifts) */
    a = 0;
    b = 5;
    result = a << b;

    if (result != 0) return 3;

    /* Test 4: Multiply by shifting - 1 << 5 = 32 */
    a = 1;
    b = 5;
    result = a << b;

    if (result != 32) return 4;

    /* Test 5: Large value addition (near max) */
    int32_t large = 2000000000;
    result = large + 100000000;

    if (result != 2100000000) return 5;

    /* Test 6: Negative to positive through zero */
    int32_t neg = -100;
    result = neg + 150;

    if (result != 50) return 6;

    /* Test 7: Bitwise AND with zero */
    a = 0xFF00;
    b = 0x0000;
    result = a & b;

    if (result != 0) return 7;

    /* Test 8: Bitwise OR with zero */
    a = 0x00FF;
    b = 0x0000;
    result = a | b;

    if (result != 0x00FF) return 8;

    /* Test 9: Bitwise XOR with same value (cancels) */
    a = 0xFFFF;
    b = 0xFFFF;
    result = a ^ b;

    if (result != 0) return 9;

    /* Test 10: Bitwise XOR with zero value (identity) */
    a = 0x5555;
    b = 0x0000;
    result = a ^ b;

    if (result != 0x5555) return 10;

    /* Test 11: Shift by zero */
    c = 12345;
    d = 0;
    result = c >> d;

    if (result != 12345) return 11;

    /* Test 12: Shift all bits away */
    c = 0x00000001;
    d = 31;
    result = c >> d;

    if (result != 0) return 12;

    /* Test 13: Shift large value right safely */
    c = 0x80000000;
    d = 16;
    result = c >> d;

    if (result != 0x8000) return 13;

    /* Test 14: Comparison of equal negatives */
    int32_t neg_a = -50, neg_b = -50;

    if (!(neg_a == neg_b)) return 14;

    /* Test 15: Comparison across sign boundary */
    int32_t pos = 10, neg_val2 = -10;

    if (!(pos > neg_val2)) return 15;

    /* Test 16: Boundary array access - first element */
    int32_t arr[5];
    arr[0] = 100;
    arr[1] = 200;
    arr[2] = 300;
    arr[3] = 400;
    arr[4] = 500;

    if (arr[0] != 100) return 16;

    /* Test 17: Boundary array access - last element */
    if (arr[4] != 500) return 17;

    /* Test 18: Pointer at boundary */
    int32_t *ptr = &arr[0];

    if (*ptr != 100) return 18;

    /* Test 19: Pointer offset to end */
    ptr = &arr[4];

    if (*ptr != 500) return 19;

    /* Test 20: All bits set in bitwise operation */
    result = 0xFFFFFFFF;

    if (result != -1) return 20;  /* -1 in two's complement */

    /* Test 21: Zero comparison in branch */
    result = 0;

    if (result == 0) {
        result = 42;
    }

    if (result != 42) return 21;

    /* Test 22: Negative as condition */
    int32_t neg_val = -1;

    if (!(neg_val != 0)) return 22;

    /* Test 23: Struct array at boundary */
    struct S {
        int32_t a;
        int32_t b;
    } structs[2];
    structs[0].a = 1;
    structs[0].b = 2;
    structs[1].a = 3;
    structs[1].b = 4;

    if (structs[1].b != 4) return 23;

    /* Test 24: Double pointer to zero address (test null pointer arithmetic) */
    int32_t *null_ptr = 0;
    int32_t **null_pptr = &null_ptr;

    if (*null_pptr != 0) return 24;

    /* Test 25: Deeply nested structure access */
    struct Nested {
        struct S inner;
    } nested;
    nested.inner.a = 10;
    nested.inner.b = 20;

    if (nested.inner.a != 10) return 25;

    /* All tests passed */
    return 0;
}
