/* Advanced pointer operations test
 * C patterns: pointer arithmetic, double pointers, pointers to arrays, pointer casting
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

int32_t main(void)
{
    int32_t result;
    /* Test 1: Basic pointer to int */
    int32_t x = 42;
    int32_t *ptr_x = &x;

    if (*ptr_x != 42) return 1;

    /* Test 2: Pointer modification */
    *ptr_x = 100;

    if (x != 100) return 2;

    /* Test 3: Pointer to array */
    int32_t arr[5];
    arr[0] = 10;
    arr[1] = 20;
    arr[2] = 30;
    arr[3] = 40;
    arr[4] = 50;
    int32_t *arr_ptr = arr;

    if (*arr_ptr != 10) return 3;

    /* Test 4: Pointer arithmetic - offset by 1 */
    arr_ptr++;

    if (*arr_ptr != 20) return 4;

    /* Test 5: Pointer arithmetic - offset by multiple */
    int32_t *ptr_offset = arr + 3;

    if (*ptr_offset != 40) return 5;

    /* Test 6: Pointer arithmetic - difference */
    int32_t *p1 = &arr[1];
    int32_t *p2 = &arr[4];
    int32_t diff = p2 - p1;

    if (diff != 3) return 6;

    /* Test 7: Double pointer - pointer to pointer */
    int32_t **pptr = &ptr_x;

    if (**pptr != 100) return 7;

    /* Test 8: Double pointer modification through dereference */
    **pptr = 200;

    if (x != 200) return 8;

    /* Test 9: Array of pointers */
    int32_t vals[3];
    vals[0] = 111;
    vals[1] = 222;
    vals[2] = 333;
    int32_t *ptrs[3];
    ptrs[0] = &vals[0];
    ptrs[1] = &vals[1];
    ptrs[2] = &vals[2];

    if (*ptrs[0] != 111) return 9;

    if (*ptrs[2] != 333) return 10;

    /* Test 10: Pointer to array of pointers */
    int32_t **ptr_to_ptrs = ptrs;

    if (**ptr_to_ptrs != 111) return 11;

    /* Test 11: Dereference through array of pointers */
    *ptrs[1] = 999;

    if (vals[1] != 999) return 12;

    /* Test 12: Pointer arithmetic on pointer array */
    int32_t **pp = ptrs;
    pp++;

    if (**pp != 999) return 13;

    /* Test 13: Pointer swap through double pointers */
    int32_t a = 10, b = 20;
    int32_t *pa = &a, *pb = &b;
    int32_t **ppa = &pa, **ppb = &pb;
    int32_t *temp = *ppa;
    *ppa = *ppb;
    *ppb = temp;

    if (pa != &b) return 14;

    if (pb != &a) return 15;

    /* Test 14: Pointer to 2D array element */
    int32_t matrix[3][3];
    matrix[1][2] = 555;
    int32_t *p_elem = &matrix[1][2];

    if (*p_elem != 555) return 16;

    /* Test 15: Pointer indexing equivalent to array indexing */
    int32_t *base_ptr = &matrix[0][0];
    *(base_ptr + 5) = 777;  /* matrix[1][2] is at offset 5 in flattened array */

    if (matrix[1][2] != 777) return 17;

    /* Test 16: Function pointer storage and call */
    int32_t (*func_ptr)(void) = 0;

    /* We can't test actual function calls without breaking nostalib semantics,
       but we can test pointer storage and comparison */
    if (func_ptr != 0) return 18;

    /* Test 17: Pointer to array of structs */
    struct Point {
        int32_t x;
        int32_t y;
    } points[2];
    points[0].x = 10;
    points[0].y = 20;
    points[1].x = 30;
    points[1].y = 40;
    struct Point *ppoint = points;

    if (ppoint->x != 10) return 19;

    ppoint++;

    if (ppoint->x != 30) return 20;

    /* Test 18: Complex pointer arithmetic with structs */
    struct Point *p_base = &points[0];
    p_base[1].y = 999;

    if (points[1].y != 999) return 21;

    /* Test 19: Pointer comparison */
    int32_t *p_a = &arr[0];
    int32_t *p_b = &arr[0];

    if (!(p_a == p_b)) return 22;

    /* Test 20: Pointer inequality */
    p_b = &arr[1];

    if (!(p_a != p_b)) return 23;

    /* Test 21: Pointer less than comparison */
    if (!(p_a < p_b)) return 24;

    /* All tests passed */
    return 0;
}
