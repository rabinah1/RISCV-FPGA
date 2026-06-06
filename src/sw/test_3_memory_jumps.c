/* Memory and jump operations test
 * Instruction coverage: LW, SW, JAL, JALR, LUI, AUIPC
 * C patterns: stack arrays, pointers, function pointers
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

/* Helper function for JALR testing */
int32_t add_op(int32_t x, int32_t y)
{
    return x + y;
}

int32_t sub_op(int32_t x, int32_t y)
{
    return x - y;
}

int32_t main(void)
{
    int32_t result;
    int32_t arr[8];
    /* Test 1: SW/LW - basic stack array write/read */
    arr[0] = 100;
    arr[1] = 200;

    if (arr[0] != 100) return 1;

    if (arr[1] != 200) return 2;

    /* Test 2: LW/SW - array element computation */
    result = arr[0] + arr[1];

    if (result != 300) return 3;

    /* Test 3: SW/LW - indexed write */
    int32_t idx = 5;
    arr[idx] = 999;

    if (arr[5] != 999) return 4;

    /* Test 4: Pointer arithmetic (SW via pointer) */
    int32_t *ptr = &arr[2];
    *ptr = 777;

    if (arr[2] != 777) return 5;

    /* Test 5: Pointer dereference (LW via pointer) */
    result = *ptr;

    if (result != 777) return 6;

    /* Test 6: Pointer offset access */
    ptr = arr;
    ptr[3] = 555;

    if (arr[3] != 555) return 7;

    /* Test 7: Double pointer (LW chain) */
    int32_t **pptr = &ptr;
    **pptr = 888;

    if (arr[0] != 888) return 8;

    /* Test 8: Pointer offset computation */
    ptr = &arr[4];
    ptr[1] = 333;

    if (arr[5] != 333) return 9;

    /* Test 9: Multiple array accesses */
    arr[6] = arr[0] + arr[5];

    if (arr[6] != (888 + 333)) return 10;

    /* Test 10: JAL - function call, result returned */
    result = add_op(10, 20);

    if (result != 30) return 11;

    /* Test 11: JAL - second function call */
    result = sub_op(15, 5);

    if (result != 10) return 12;

    /* Test 12: JAL - multiple calls in sequence */
    int32_t a1 = add_op(5, 3);
    int32_t a2 = sub_op(10, 2);

    if (a1 != 8 || a2 != 8) return 13;

    /* Test 13: Function pointer via simple assignment */
    int32_t (*func_ptr)(int32_t, int32_t) = add_op;
    result = func_ptr(7, 8);

    if (result != 15) return 14;

    /* Test 14: Function pointer to different function */
    func_ptr = sub_op;
    result = func_ptr(20, 5);

    if (result != 15) return 15;

    /* Test 15: Nested pointer dereference - pointer to array of pointers */
    int32_t val_a = 111, val_b = 222, val_c = 333;
    int32_t *ptrs[3];
    ptrs[0] = &val_a;
    ptrs[1] = &val_b;
    ptrs[2] = &val_c;

    if (*ptrs[0] != 111) return 16;

    if (*ptrs[1] != 222) return 17;

    if (*ptrs[2] != 333) return 18;

    /* Test 16: Complex pointer arithmetic (array of pointers to array elements) */
    int32_t values[4];
    values[0] = 10;
    values[1] = 20;
    values[2] = 30;
    values[3] = 40;
    int32_t *pv = &values[1];
    result = *pv + *(pv + 1) + *(pv + 2);

    if (result != (20 + 30 + 40)) return 19;

    /* Test 17: Function pointer in conditional */
    int32_t (*selected_op)(int32_t, int32_t);
    selected_op = (100 > 50) ? add_op : sub_op;
    result = selected_op(10, 5);

    if (result != 15) return 20;

    /* All tests passed */
    return 0;
}
