#include <stdint.h>

#define IS_DEAD 0
#define IS_ALIVE 1
#define BECOMES_ALIVE 2
#define BECOMES_DEAD 3
#define NUM_GENERATIONS 5
#define NUM_ROWS 16
#define NUM_COLS 16

uint32_t main(void)
{
    uint32_t matrix[NUM_ROWS][NUM_COLS];
    uint32_t row_idx = 0;
    uint32_t col_idx = 0;
    uint32_t idx_sum = 0;
    uint32_t num_live_neighbors = 0;
    uint32_t generation = 0;
    uint32_t idx = 0;

    for (row_idx = 0; row_idx < NUM_ROWS; row_idx++) {
        for (col_idx = 0; col_idx < NUM_COLS; col_idx++) {
            if (row_idx >= 5 && row_idx <= 10 && col_idx >= 5 && col_idx <= 10)
                matrix[row_idx][col_idx] = IS_ALIVE;
            else
                matrix[row_idx][col_idx] = IS_DEAD;
        }
    }

    for (generation = 0; generation < NUM_GENERATIONS; generation++) {
        for (row_idx = 0; row_idx < NUM_ROWS; row_idx++) {
            for (col_idx = 0; col_idx < NUM_COLS; col_idx++) {
                num_live_neighbors = 0;

                if (row_idx > 0 && col_idx > 0) {
                    if (matrix[row_idx - 1][col_idx - 1] == IS_ALIVE
                        || matrix[row_idx - 1][col_idx - 1] == BECOMES_DEAD)
                        num_live_neighbors = num_live_neighbors + 1;
                }

                if (row_idx > 0) {
                    if (matrix[row_idx - 1][col_idx] == IS_ALIVE || matrix[row_idx - 1][col_idx] == BECOMES_DEAD)
                        num_live_neighbors = num_live_neighbors + 1;
                }

                if (row_idx > 0 && col_idx < NUM_COLS - 1) {
                    if (matrix[row_idx - 1][col_idx + 1] == IS_ALIVE
                        || matrix[row_idx - 1][col_idx + 1] == BECOMES_DEAD)
                        num_live_neighbors = num_live_neighbors + 1;
                }

                if (col_idx > 0) {
                    if (matrix[row_idx][col_idx - 1] == IS_ALIVE || matrix[row_idx][col_idx - 1] == BECOMES_DEAD)
                        num_live_neighbors = num_live_neighbors + 1;
                }

                if (col_idx < NUM_COLS - 1) {
                    if (matrix[row_idx][col_idx + 1] == IS_ALIVE || matrix[row_idx][col_idx + 1] == BECOMES_DEAD)
                        num_live_neighbors = num_live_neighbors + 1;
                }

                if (row_idx < NUM_ROWS - 1 && col_idx > 0) {
                    if (matrix[row_idx + 1][col_idx - 1] == IS_ALIVE
                        || matrix[row_idx + 1][col_idx - 1] == BECOMES_DEAD)
                        num_live_neighbors = num_live_neighbors + 1;
                }

                if (row_idx < NUM_ROWS - 1) {
                    if (matrix[row_idx + 1][col_idx] == IS_ALIVE || matrix[row_idx + 1][col_idx] == BECOMES_DEAD)
                        num_live_neighbors = num_live_neighbors + 1;
                }

                if (row_idx < NUM_ROWS - 1 && col_idx < NUM_COLS - 1) {
                    if (matrix[row_idx + 1][col_idx + 1] == IS_ALIVE
                        || matrix[row_idx + 1][col_idx + 1] == BECOMES_DEAD)
                        num_live_neighbors = num_live_neighbors + 1;
                }

                if (matrix[row_idx][col_idx] == IS_ALIVE && (num_live_neighbors < 2 || num_live_neighbors > 3))
                    matrix[row_idx][col_idx] = BECOMES_DEAD;

                if (matrix[row_idx][col_idx] == IS_DEAD && num_live_neighbors == 3)
                    matrix[row_idx][col_idx] = BECOMES_ALIVE;
            }
        }

        idx_sum = 0;
        idx = 0;

        for (row_idx = 0; row_idx < NUM_ROWS; row_idx++) {
            for (col_idx = 0; col_idx < NUM_COLS; col_idx++) {
                if (matrix[row_idx][col_idx] == IS_ALIVE)
                    idx_sum = idx_sum + idx;

                if (matrix[row_idx][col_idx] == BECOMES_ALIVE) {
                    matrix[row_idx][col_idx] = IS_ALIVE;
                    idx_sum = idx_sum + idx;
                }

                if (matrix[row_idx][col_idx] == BECOMES_DEAD)
                    matrix[row_idx][col_idx] = IS_DEAD;

                idx = idx + 1;
            }
        }
    }

    return idx_sum;
}
