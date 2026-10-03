#include <stdint.h>

#define WINDOW_LEN 5

uint32_t main(void)
{
    int32_t raw_data[] = {58, 34, 45, 50, 1, 5, -3, 7, -100, -120, -95, -74, 340, 300, 354, 322, 1000, 1048, 942, 1100};
    uint32_t num_of_input_elements = sizeof(raw_data) / sizeof(raw_data[0]);
    int32_t filtered_data[num_of_elements - WINDOW_LEN + 1] = { 0 };
    uint32_t num_of_output_elements = sizeof(filtered_data) / sizeof(filtered_data[0]);
    int32_t filtered_sum = 0;

    for (uint32_t idx = 0; idx < num_of_output_elements; idx++) {
        filtered_data[idx] = (raw_data[idx] + raw_data[idx+1] + raw_data[idx+2]) / WINDOW_LEN;
	filtered_sum = filtered_sum + filtered_data[idx];
    }

    return filtered_sum;
}
