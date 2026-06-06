/* Comprehensive branch and comparison operations test
 * Instruction coverage: BEQ, BNE, BLT, BGE, BLTU, BGEU,
 *                       SLT, SLTI, SLTU, SLTIU
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

/* Recursive function - sum of integers from 1 to n via addition */
int sum_to_n(int n)
{
    if (n <= 0) {
        return 0;
    }

    return n + sum_to_n(n - 1);
}

int main(void)
{
    int32_t a, b, result;
    uint32_t c, d;
    /* Test 1: BEQ - equal values */
    a = 100;
    b = 100;

    if (!(a == b)) return 1;

    /* Test 2: BNE - not equal */
    a = 100;
    b = 50;

    if (!(a != b)) return 2;

    /* Test 3: BLT - signed less than (positive) */
    a = 5;
    b = 10;

    if (!(a < b)) return 3;

    /* Test 4: BLT - signed less than (negative to positive) */
    a = -10;
    b = 5;

    if (!(a < b)) return 4;

    /* Test 5: BLT - signed less than (negative to negative) */
    a = -50;
    b = -10;

    if (!(a < b)) return 5;

    /* Test 6: BGE - greater or equal (positive) */
    a = 100;
    b = 50;

    if (!(a >= b)) return 6;

    /* Test 7: BGE - equal values */
    a = 50;
    b = 50;

    if (!(a >= b)) return 7;

    /* Test 8: BLTU - unsigned less than */
    c = 10;
    d = 100;

    if (!(c < d)) return 8;

    /* Test 9: BGEU - unsigned greater or equal */
    c = 100;
    d = 50;

    if (!(c >= d)) return 9;

    /* Test 10: SLT - signed less than computation */
    a = -5;
    b = 10;
    result = (a < b) ? 1 : 0;

    if (result != 1) return 10;

    /* Test 11: SLT - signed not less than */
    a = 100;
    b = 50;
    result = (a < b) ? 1 : 0;

    if (result != 0) return 11;

    /* Test 12: SLTI - compare with immediate */
    a = 25;
    result = (a < 50) ? 1 : 0;

    if (result != 1) return 12;

    /* Test 13: SLTU - unsigned comparison */
    c = 100;
    d = 200;
    result = (c < d) ? 1 : 0;

    if (result != 1) return 13;

    /* Test 14: SLTIU - unsigned immediate */
    c = 75;
    result = (c < 100) ? 1 : 0;

    if (result != 1) return 14;

    /* Test 15: Complex condition - nested comparisons */
    a = 50;
    b = 100;

    if (!((a < b) && (b > 0))) return 15;

    /* Test 16: Ternary with branch ops */
    a = 10;
    b = 20;
    result = (a != b) ? (a < b ? 1 : 2) : 3;

    if (result != 1) return 16;

    /* Test 17: JAL + recursion test
     * sum_to_n(5) = 5+4+3+2+1 = 15;
     */
    result = sum_to_n(5);

    if (result != 15) return 17;

    /* Test 18: Multiple function calls in sequence */
    int32_t s1 = sum_to_n(3);  /* 6 */
    int32_t s2 = sum_to_n(4);  /* 10 */

    if (s1 != 6 || s2 != 10) return 18;

    /* Test 19: Comparison chain */
    a = 5;
    b = 10;

    if (!((a < b) && (b < 20) && (20 > a))) return 19;

    /* All tests passed */
    return 0;
}
