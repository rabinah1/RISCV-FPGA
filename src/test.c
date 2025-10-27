#include <stdint.h>

uint32_t test_function(uint32_t c, uint32_t res)
{
    uint32_t x = 5;
    uint32_t y = 100;
    uint32_t ret = 0;

    if (res > c)
        ret = y - x + res;
    else
        ret = y - x + c;

    return ret;
}

uint32_t main(void)
{
    uint32_t a = 12;
    uint32_t b = 5;
    uint32_t c = 56;
    uint32_t d = 30;
    uint32_t res = 0;
    uint32_t idx = 0;

    if (a >= b) {
        res = a - b;
        for (uint32_t i  = 0; i < 10; i++)
            res = res + i;
    } else {
        res = a + b;
    }

    if (c <= d) {
        res = res + c;
    } else {
        res = res + d + test_function(c, res);
        while (idx < 10) {
            res = res - idx;
            idx = idx + 3;
        }
    }

    return res;
}
