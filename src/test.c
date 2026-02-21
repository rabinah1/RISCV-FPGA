#include <stdint.h>

struct my_struct {
    int32_t member_1;
    int32_t member_2;
    int32_t member_3;
    int32_t member_4;
};

int32_t test_function(int32_t c, int32_t res)
{
    int32_t x = 5;
    int32_t y = 100;
    int32_t ret = 0;

    if (res > c)
        ret = y - x + res;
    else
        ret = y - x + c;

    return ret;
}

int32_t test_recursion(int32_t k)
{
    if (k > 0)
        return k + test_recursion(k - 1);
    else
        return 0;
}

void modify_array(int32_t *arr)
{
    arr[2] = 100;
    arr[4] = -20;
}

int32_t main(void)
{
    int32_t a = 12;
    int32_t b = 5;
    int32_t c = 56;
    int32_t d = 30;
    int32_t res = 0;
    int32_t idx = 0;
    int32_t item_1 = 1;
    int32_t item_2 = 2;
    int32_t item_3 = 3;
    int32_t item_4 = 4;
    int32_t item_5 = 5;
    int32_t arr[] = {item_1, item_2, item_3, item_4, item_5};
    struct my_struct s;
    s.member_1 = 5;
    s.member_2 = 10;
    s.member_3 = 15;
    s.member_4 = 20;

    if (a >= b) {
        res = a - b + test_recursion(10) - s.member_1;

        for (int32_t i  = 0; i < 10; i++)
            res = res + i;
    } else {
        res = a + b - s.member_2;
    }

    if (c <= d) {
        res = res + c - s.member_3;
    } else {
        res = res + d + test_function(c, res) - s.member_4;

        while (idx < 10) {
            res = res - idx;
            idx = idx + 3;
        }
    }

    modify_array(arr);

    for (int32_t i = 0; i < 5; i++)
        res = res + arr[i];

    return res;
}
