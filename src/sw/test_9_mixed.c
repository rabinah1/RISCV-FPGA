/* Mixed comprehensive test combining multiple instruction types and C patterns
 * Covers: arithmetic, branches, memory ops, structs, arrays, recursion
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

struct DataPoint {
    int32_t id;
    int32_t value;
    int32_t timestamp;
};

/* Simple string-like character counting (no string.h) */
int32_t count_sum(int32_t *data, int32_t len)
{
    if (len <= 0) return 0;

    return data[len - 1] + count_sum(data, len - 1);
}

int32_t main(void)
{
    int32_t result, i, j;
    /* Test 1: Arithmetic + branching combo */
    int32_t x = 50, y = 30;

    if (x > y) {
        result = x + y;
    } else {
        result = x - y;
    }

    if (result != 80) return 1;

    /* Test 2: Loop with memory operations */
    int32_t buffer[8];

    for (i = 0; i < 8; i++) {
        buffer[i] = i << 3;  /* i * 8 via shift, or use repeated addition */
    }

    if (buffer[3] != 24) return 2;

    if (buffer[7] != 56) return 3;

    /* Test 3: Array accumulation with conditionals */
    result = 0;

    for (i = 0; i < 8; i++) {
        if (buffer[i] > 20) {
            result += buffer[i];
        }
    }

    if (result != (24 + 32 + 40 + 48 + 56)) return 4;

    /* Test 4: 2D array processing */
    int32_t matrix[3][3];
    matrix[0][0] = 1;
    matrix[0][1] = 2;
    matrix[0][2] = 3;
    matrix[1][0] = 4;
    matrix[1][1] = 5;
    matrix[1][2] = 6;
    matrix[2][0] = 7;
    matrix[2][1] = 8;
    matrix[2][2] = 9;
    result = matrix[0][0] + matrix[1][1] + matrix[2][2];

    if (result != 15) return 5;

    /* Test 5: Struct operations */
    struct DataPoint points[3];
    points[0].id = 1;
    points[0].value = 100;
    points[1].id = 2;
    points[1].value = 200;
    points[2].id = 3;
    points[2].value = 300;
    result = 0;

    for (i = 0; i < 3; i++) {
        result += points[i].value;
    }

    if (result != 600) return 6;

    /* Test 6: Pointer to struct with array */
    struct DataPoint *dp_ptr = &points[1];

    if (dp_ptr->value != 200) return 7;

    /* Test 7: Complex pointer arithmetic with 2D array */
    int32_t flat_data[6];
    flat_data[0] = 1;
    flat_data[1] = 2;
    flat_data[2] = 3;
    flat_data[3] = 4;
    flat_data[4] = 5;
    flat_data[5] = 6;
    int32_t *ptr = &flat_data[2];
    result = *ptr + *(ptr + 1) + *(ptr + 2);

    if (result != 12) return 8;

    /* Test 8: Recursion with array processing */
    result = count_sum(buffer, 8);

    if (result != (0 + 8 + 16 + 24 + 32 + 40 + 48 + 56)) return 9;

    /* Test 9: Nested loops with conditionals */
    result = 0;

    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            if (i == j) {
                result += matrix[i][j];
            }
        }
    }

    if (result != (1 + 5 + 9)) return 10;

    /* Test 10: Array of pointers with dereferencing */
    int32_t val_a = 111, val_b = 222, val_c = 333;
    int32_t *ptr_array[3];
    ptr_array[0] = &val_a;
    ptr_array[1] = &val_b;
    ptr_array[2] = &val_c;
    result = *ptr_array[0] + *ptr_array[2];

    if (result != 444) return 11;

    /* Test 11: Complex expression with all operations */
    int32_t a = 10, b = 20, c = 30;
    int32_t arr[3];
    arr[0] = 5;
    arr[1] = 10;
    arr[2] = 15;
    result = ((a + b) << 1) - (c - arr[1]);  /* (30 << 1) - (30 - 10) = 60 - 20 = 40 */

    if (result != 40) return 12;

    /* Test 12: Bitwise operations in real context */
    uint32_t flags = 0xFF00;
    uint32_t mask = 0xF000;
    result = (flags & mask) >> 4;

    if (result != 0xF00) return 13;

    /* Test 13: Struct field chaining and arithmetic */
    struct DataPoint *selected = &points[1];

    if (selected->id != 2) return 14;

    if (selected->value != 200) return 15;

    /* Test 14: Loop with early exit via condition */
    result = 0;

    for (i = 0; i < 8; i++) {
        if (buffer[i] > 50) {
            result = buffer[i];
            break;
        }
    }

    if (result != 56) return 16;

    /* All tests passed */
    return 0;
}
