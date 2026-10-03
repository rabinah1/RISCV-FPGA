#include <stdint.h>

#define WINDOW_LEN 5

uint32_t main(void)
{
    // raw_data cannot be initialized directly here, since that would try to call memset, which is not supported in the processor implementation.
    int32_t raw_data[100];
    raw_data[0] = 4115;
    raw_data[1] = 4200;
    raw_data[2] = 3985;
    raw_data[3] = 3899;
    raw_data[4] = 4000;
    raw_data[5] = 4050;
    raw_data[6] = 4150;
    raw_data[7] = 4300;
    raw_data[8] = 3850;
    raw_data[9] = 3921;
    raw_data[10] = 2238;
    raw_data[11] = 2190;
    raw_data[12] = 1958;
    raw_data[13] = 1900;
    raw_data[14] = 2111;
    raw_data[15] = 1890;
    raw_data[16] = 1942;
    raw_data[17] = 1945;
    raw_data[18] = 1830;
    raw_data[19] = 2045;
    raw_data[20] = 50;
    raw_data[21] = 24;
    raw_data[22] = -10;
    raw_data[23] = 5;
    raw_data[24] = -2;
    raw_data[25] = -34;
    raw_data[26] = 89;
    raw_data[27] = -100;
    raw_data[28] = -33;
    raw_data[29] = 88;
    raw_data[30] = -1942;
    raw_data[31] = -2165;
    raw_data[32] = -2222;
    raw_data[33] = -1867;
    raw_data[34] = -2041;
    raw_data[35] = -1952;
    raw_data[36] = -1832;
    raw_data[37] = -2174;
    raw_data[38] = -2249;
    raw_data[39] = -1999;
    raw_data[40] = -4174;
    raw_data[41] = -3857;
    raw_data[42] = -3961;
    raw_data[43] = -3981;
    raw_data[44] = -4000;
    raw_data[45] = -4289;
    raw_data[46] = -4193;
    raw_data[47] = -3994;
    raw_data[48] = -3801;
    raw_data[49] = -3900;
    raw_data[50] = -1853;
    raw_data[51] = -1983;
    raw_data[52] = -2165;
    raw_data[53] = -2269;
    raw_data[54] = -2200;
    raw_data[55] = -2001;
    raw_data[56] = -1995;
    raw_data[57] = -1936;
    raw_data[58] = -1820;
    raw_data[59] = -1899;
    raw_data[60] = 164;
    raw_data[61] = 51;
    raw_data[62] = 100;
    raw_data[63] = -34;
    raw_data[64] = -29;
    raw_data[65] = -149;
    raw_data[66] = 0;
    raw_data[67] = -3;
    raw_data[68] = 11;
    raw_data[69] = 167;
    raw_data[70] = 1911;
    raw_data[71] = 2000;
    raw_data[72] = 2005;
    raw_data[73] = 2099;
    raw_data[74] = 2158;
    raw_data[75] = 1847;
    raw_data[76] = 1888;
    raw_data[77] = 1933;
    raw_data[78] = 1991;
    raw_data[79] = 2109;
    raw_data[80] = 4000;
    raw_data[81] = 4009;
    raw_data[82] = 4164;
    raw_data[83] = 4009;
    raw_data[84] = 3954;
    raw_data[85] = 3851;
    raw_data[86] = 3910;
    raw_data[87] = 4105;
    raw_data[88] = 4250;
    raw_data[89] = 4199;
    raw_data[90] = 2109;
    raw_data[91] = 2263;
    raw_data[92] = 1942;
    raw_data[93] = 1803;
    raw_data[94] = 1875;
    raw_data[95] = 1930;
    raw_data[96] = 2185;
    raw_data[97] = 2140;
    raw_data[98] = 2274;
    raw_data[99] = 2007;
    uint32_t num_of_input_elements = sizeof(raw_data) / sizeof(raw_data[0]);
    int32_t filtered_data[num_of_input_elements - WINDOW_LEN + 1];
    uint32_t num_of_output_elements = sizeof(filtered_data) / sizeof(filtered_data[0]);
    int32_t filtered_sum = 0;

    for (uint32_t idx = 0; idx < num_of_output_elements; idx++) {
        filtered_data[idx] = (raw_data[idx] + raw_data[idx + 1] + raw_data[idx + 2] + raw_data[idx + 3] +
                              raw_data[idx + 4]) / WINDOW_LEN;
        filtered_sum = filtered_sum + filtered_data[idx];
    }

    if (filtered_data[37] != -2890) {
        return -1;
    }

    return filtered_sum;
}
