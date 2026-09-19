/* Comprehensive arithmetic and logical operations test
 * Instruction coverage: ADD, ADDI, SUB, SLL, SLLI, SRL, SRLI,
 *                       AND, ANDI, OR, ORI, XOR, XORI
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

int main(void)
{
    int32_t a;
    int32_t b;
    uint32_t c;
    uint32_t d;
    int32_t result;
    /* Test 1: ADD basic */
    a = 100;
    b = 200;
    result = a + b;

    if (result != 300) return 1;

    /* Test 2: SUB basic */
    a = 500;
    b = 200;
    result = a - b;

    if (result != 300) return 2;

    /* Test 3: SUB with negative result */
    a = 100;
    b = 300;
    result = a - b;

    if (result != -200) return 3;

    /* Test 4: ADD negative numbers */
    a = -100;
    b = -50;
    result = a + b;

    if (result != -150) return 4;

    /* Test 5: SLL - shift left logical by 1 */
    a = 10;
    b = 1;
    result = a << b;

    if (result != 20) return 5;

    /* Test 6: SLL - shift left logical by 4 */
    a = 7;
    b = 4;
    result = a << b;

    if (result != 112) return 6;

    /* Test 7: SLL - shift left by 0 (no-op) */
    a = 42;
    b = 0;
    result = a << b;

    if (result != 42) return 7;

    /* Test 8: SLLI with larger shift */
    a = 1;
    b = 15;
    result = a << b;

    if (result != 32768) return 8;

    /* Test 9: SRL - shift right logical by 1 */
    c = 20;
    d = 1;
    result = c >> d;

    if (result != 10) return 9;

    /* Test 10: SRL - shift right logical by 4 */
    c = 112;
    d = 4;
    result = c >> d;

    if (result != 7) return 10;

    /* Test 11: SRL - shift right of negative (unsigned semantics) */
    c = 0x80000000;
    d = 1;
    result = c >> d;

    if (result != 0x40000000) return 11;

    /* Test 12: AND - all bits clear */
    a = 0xFF00;
    b = 0x00FF;
    result = a & b;

    if (result != 0) return 12;

    /* Test 13: AND - some bits set */
    a = 0xF0F0;
    b = 0x0FF0;
    result = a & b;

    if (result != 0x00F0) return 13;

    /* Test 14: OR - combine bits */
    a = 0xF0;
    b = 0x0F;
    result = a | b;

    if (result != 0xFF) return 14;

    /* Test 15: XOR - same values cancel */
    a = 0xAA;
    b = 0xAA;
    result = a ^ b;

    if (result != 0) return 15;

    /* Test 16: XOR - complement pattern */
    a = 0xAA;
    b = 0x55;
    result = a ^ b;

    if (result != 0xFF) return 16;

    /* Test 17: Chained operations - (a + b) & 0xFF */
    a = 0x1234;
    b = 0x5678;
    c = 0xFFFF;
    result = (a + b) & c;

    if (result != 0x68AC) return 17;

    /* Test 18: Complex: ((a << 2) | (b >> 1)) ^ c */
    c = 5;
    d = 16;
    a = 12;
    result = ((c << 2) | (d >> 1)) ^ a;

    if (result != ((20 | 8) ^ 12)) return 18;

    /* Test 19: ADD with multiple operands */
    int32_t op_1 = 1;
    int32_t op_2 = 2;
    int32_t op_3 = 3;
    int32_t op_4 = 4;
    int32_t op_5 = 5;
    result = op_1 + op_2 + op_3 + op_4 + op_5;

    if (result != 15) return 19;

    /* Test 20: MUL basic both positive */
    op_1 = 15;
    op_2 = 88;
    result = op_1 * op_2;

    if (result != 1320) return 20;

    /* Test 21: MUL basic both negative */
    op_1 = -15;
    op_2 = -88;
    result = op_1 * op_2;

    if (result != 1320) return 21;

    /* Test 22: MUL basic positive and negative */
    op_1 = 15;
    op_2 = -88;
    result = op_1 * op_2;

    if (result != -1320) return 22;

    /* Test 23: MULH basic both positive */
    op_1 = 5;
    op_2 = 2000000000;
    result = (int32_t)(((int64_t)op_1 * (int64_t)op_2) >> 32);

    if (result != 2) return 23;

    /* Test 24: MULH basic both negative */
    op_1 = -5;
    op_2 = -2000000000;
    result = (int32_t)(((int64_t)op_1 * (int64_t)op_2) >> 32);

    if (result != 2) return 24;

    /* Test 25: MULH basic positive and negative */
    op_1 = -5;
    op_2 = 2000000000;
    result = (int32_t)(((int64_t)op_1 * (int64_t)op_2) >> 32);

    if (result != -3) return 25;

    /* Test 26: MULSU basic both positive */
    op_1 = 5;
    uint32_t op_2_u = 2000000000;
    result = (int32_t)(((int64_t)op_1 * (uint64_t)op_2_u) >> 32);

    if (result != 2) return 26;

    /* Test 27: MULSU basic both negative */
    op_1 = -5;
    op_2_u = -2000000000;
    result = (int32_t)(((int64_t)op_1 * (uint64_t)op_2_u) >> 32);

    if (result != -3) return 27;

    /* Test 28: MULSU basic positive and negative */
    op_1 = 5;
    op_2_u = -2000000000;
    result = (int32_t)(((int64_t)op_1 * (uint64_t)op_2_u) >> 32);

    if (result != 2) return 28;

    /* Test 29: MULU basic both positive */
    uint32_t op_1_u = 5;
    op_2_u = 2000000000;
    result = (int32_t)(((uint64_t)op_1_u * (uint64_t)op_2_u) >> 32);

    if (result != 2) return 29;

    /* Test 30: MULU basic both negative */
    op_1_u = -500000000;
    op_2_u = -300000000;
    result = (int32_t)(((uint64_t)op_1_u * (uint64_t)op_2_u) >> 32);

    if (result != -765075404) return 30;

    /* Test 31: MULU basic positive and negative */
    op_1_u = -5;
    op_2_u = 2000000000;
    result = (int32_t)(((uint64_t)op_1_u * (uint64_t)op_2_u) >> 32);

    if (result != 1999999997) return 31;

    /* Test 32: DIV basic both positive */
    op_1 = 22;
    op_2 = 5;
    result = op_1 / op_2;

    if (result != 4) return 32;

    /* Test 33: DIV basic both negative */
    op_1 = -22;
    op_2 = -5;
    result = op_1 / op_2;

    if (result != 4) return 33;

    /* Test 34: DIV basic positive and negative */
    op_1 = -22;
    op_2 = 5;
    result = op_1 / op_2;

    if (result != -4) return 34;

    /* Test 35: DIVU basic both positive */
    op_1_u = 22;
    op_2_u = 5;
    result = op_1_u / op_2_u;

    if (result != 4) return 35;

    /* Test 36: DIVU basic both negative */
    op_1_u = -22;
    op_2_u = -900000000;
    result = op_1_u / op_2_u;

    if (result != 1) return 36;

    /* Test 37: DIVU basic positive and negative */
    op_1_u = -22;
    op_2_u = 5;
    result = op_1_u / op_2_u;

    if (result != 858993454) return 37;

    /* Test 38: REM basic both positive */
    op_1 = 22;
    op_2 = 5;
    result = op_1 % op_2;

    if (result != 2) return 38;

    /* Test 39: REM basic both negative */
    op_1 = -22;
    op_2 = -5;
    result = op_1 % op_2;

    if (result != -2) return 39;

    /* Test 40: REM basic negative dividend */
    op_1 = -22;
    op_2 = 5;
    result = op_1 % op_2;

    if (result != -2) return 40;

    /* Test 41: REM basic negative divisor */
    op_1 = 22;
    op_2 = -5;
    result = op_1 % op_2;

    if (result != 2) return 41;

    /* Test 42: REMU basic both positive */
    op_1_u = 22;
    op_2_u = 5;
    result = op_1_u % op_2_u;

    if (result != 2) return 42;

    /* Test 43: REMU basic both negative */
    op_1_u = -22;
    op_2_u = -5;
    result = op_1_u % op_2_u;

    if (result != -22) return 43;

    /* Test 44: REMU basic negative divisor */
    op_1_u = 22;
    op_2_u = -5;
    result = op_1_u % op_2_u;

    if (result != 22) return 44;

    /* Test 45: REMU basic negative dividend */
    op_1_u = -22;
    op_2_u = 5;
    result = op_1_u % op_2_u;

    if (result != 4) return 45;

    /* All tests passed */
    return 0;
}
