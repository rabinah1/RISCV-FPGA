/* Recursion patterns test
 * C patterns: simple recursion, mutual recursion, tail recursion, complex recursion
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

/* Simple recursion - sum from n to 0 */
int32_t sum_down(int32_t n)
{
    if (n <= 0) return 0;

    return n + sum_down(n - 1);
}

/* Recursion with accumulation - sum via doubling */
int32_t sum_doubled(int32_t n)
{
    if (n <= 0) return 0;

    return (n + n) + sum_doubled(n - 1);  /* n+n = 2n without using * */
}

/* Recursion with multiple recursive calls - fibonacci */
int32_t fibonacci(int32_t n)
{
    if (n <= 1) return n;

    return fibonacci(n - 1) + fibonacci(n - 2);
}

/* Recursion with deep nesting - sum array */
int32_t sum_array(int32_t *arr, int32_t len)
{
    if (len <= 0) return 0;

    return arr[len - 1] + sum_array(arr, len - 1);
}

/* Mutual recursion - is_even and is_odd */
int32_t is_odd(int32_t n);
int32_t is_even(int32_t n)
{
    if (n == 0) return 1;

    return is_odd(n - 1);
}
int32_t is_odd(int32_t n)
{
    if (n == 0) return 0;

    return is_even(n - 1);
}

/* Tail recursion - countdown */
int32_t countdown(int32_t n)
{
    if (n <= 0) return 0;

    return countdown(n - 1) + 1;
}

int32_t main(void)
{
    int32_t result;
    /* Test 1: Simple recursion - sum_down(3) = 6 */
    result = sum_down(3);

    if (result != 6) return 1;

    /* Test 2: sum_down(4) = 10 */
    result = sum_down(4);

    if (result != 10) return 2;

    /* Test 3: sum_down(5) = 15 */
    result = sum_down(5);

    if (result != 15) return 3;

    /* Test 4: Doubled recursion - sum_doubled(3) = 2*3 + 2*2 + 2*1 = 12 */
    result = sum_doubled(3);

    if (result != 12) return 4;

    /* Test 5: sum_doubled(2) = 2*2 + 2*1 = 6 */
    result = sum_doubled(2);

    if (result != 6) return 5;

    /* Test 6: sum_doubled with zero */
    result = sum_doubled(0);

    if (result != 0) return 6;

    /* Test 7: Fibonacci - fib(5) = 5 (0,1,1,2,3,5) */
    result = fibonacci(5);

    if (result != 5) return 7;

    /* Test 8: Fibonacci - fib(6) = 8 */
    result = fibonacci(6);

    if (result != 8) return 8;

    /* Test 9: Fibonacci - fib(7) = 13 */
    result = fibonacci(7);

    if (result != 13) return 9;

    /* Test 10: Array sum via recursion */
    int32_t values[4];
    values[0] = 1;
    values[1] = 2;
    values[2] = 3;
    values[3] = 4;
    result = sum_array(values, 4);

    if (result != 10) return 10;

    /* Test 11: Array sum with partial array */
    result = sum_array(values, 2);

    if (result != 3) return 11;

    /* Test 12: Array sum with single element */
    result = sum_array(values, 1);

    if (result != 1) return 12;

    /* Test 13: Mutual recursion - is_even(4) = 1 */
    result = is_even(4);

    if (result != 1) return 13;

    /* Test 14: Mutual recursion - is_even(5) = 0 */
    result = is_even(5);

    if (result != 0) return 14;

    /* Test 15: Mutual recursion - is_odd(3) = 1 */
    result = is_odd(3);

    if (result != 1) return 15;

    /* Test 16: Mutual recursion - is_odd(4) = 0 */
    result = is_odd(4);

    if (result != 0) return 16;

    /* Test 17: Tail recursion - countdown(5) = 5 */
    result = countdown(5);

    if (result != 5) return 17;

    /* Test 18: Tail recursion - countdown(10) = 10 */
    result = countdown(10);

    if (result != 10) return 18;

    /* Test 19: Mixed recursion - sum_down + fibonacci */
    result = sum_down(4) + fibonacci(5);

    if (result != 15) return 19;

    /* Test 20: Nested recursion calls */
    result = fibonacci(6) + sum_down(3);

    if (result != 14) return 20;

    /* All tests passed */
    return 0;
}
