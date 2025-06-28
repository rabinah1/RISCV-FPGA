#include <stdint.h>

int main(void)
{
    uint32_t a = 12;
    uint32_t b = 5;
    uint32_t c = 56;
    uint32_t d = 30;
    uint32_t res = 0;

    if (a >= b)
	res = a - b;
    else
	res = a + b;

    if (c <= d)
	res = res + c;
    else
	res = res + d;

    return res;
}
