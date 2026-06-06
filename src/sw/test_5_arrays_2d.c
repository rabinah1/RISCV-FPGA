/* Multi-dimensional arrays test
 * C patterns: 2D arrays, 3D arrays, matrix operations
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

int32_t main(void)
{
    int32_t result;
    /* Test 1: 2D array creation and access */
    int32_t matrix[3][3];
    matrix[0][0] = 1;
    matrix[0][1] = 2;
    matrix[0][2] = 3;

    if (matrix[0][0] != 1) return 1;

    if (matrix[0][2] != 3) return 2;

    /* Test 2: Fill 2D array */
    matrix[1][0] = 4;
    matrix[1][1] = 5;
    matrix[1][2] = 6;
    matrix[2][0] = 7;
    matrix[2][1] = 8;
    matrix[2][2] = 9;

    if (matrix[2][2] != 9) return 3;

    /* Test 3: 2D array - sum row */
    result = matrix[0][0] + matrix[0][1] + matrix[0][2];

    if (result != 6) return 4;

    /* Test 4: 2D array - sum column */
    result = matrix[0][0] + matrix[1][0] + matrix[2][0];

    if (result != 12) return 5;

    /* Test 5: 2D array - sum all elements */
    result = 0;
    int32_t i, j;

    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            result += matrix[i][j];
        }
    }

    if (result != 45) return 6;

    /* Test 6: 2D array - diagonal sum */
    result = matrix[0][0] + matrix[1][1] + matrix[2][2];

    if (result != 15) return 7;

    /* Test 7: 3D array - small cube */
    int32_t cube[2][2][2];
    cube[0][0][0] = 1;
    cube[0][0][1] = 2;
    cube[0][1][0] = 3;
    cube[0][1][1] = 4;
    cube[1][0][0] = 5;
    cube[1][0][1] = 6;
    cube[1][1][0] = 7;
    cube[1][1][1] = 8;

    if (cube[0][0][0] != 1) return 8;

    if (cube[1][1][1] != 8) return 9;

    /* Test 8: 3D array - iterate and sum all */
    result = 0;
    int32_t k;

    for (i = 0; i < 2; i++) {
        for (j = 0; j < 2; j++) {
            for (k = 0; k < 2; k++) {
                result += cube[i][j][k];
            }
        }
    }

    if (result != 36) return 10;

    /* Test 9: 2D array with non-zero base */
    int32_t data[4][5];
    data[3][4] = 100;

    if (data[3][4] != 100) return 11;

    /* Test 10: Fill pattern in 2D array */
    int32_t grid[4][4];

    for (i = 0; i < 4; i++) {
        for (j = 0; j < 4; j++) {
            grid[i][j] = i * 4 + j;
        }
    }

    if (grid[0][0] != 0) return 12;

    if (grid[1][2] != 6) return 13;

    if (grid[3][3] != 15) return 14;

    /* Test 11: 2D array pointer access */
    int32_t *ptr = &matrix[0][0];

    if (*ptr != 1) return 15;

    *(ptr + 1) = 99;

    if (matrix[0][1] != 99) return 16;

    /* Test 12: Transposed matrix check (conceptual) */
    int32_t trans[3][3];

    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            trans[j][i] = matrix[i][j];
        }
    }

    if (trans[0][1] != 4) return 17;

    if (trans[2][0] != 3) return 18;

    /* Test 13: Rectangular array (non-square) */
    int32_t rect[2][5];
    rect[0][0] = 10;
    rect[0][1] = 20;
    rect[0][2] = 30;
    rect[0][3] = 40;
    rect[0][4] = 50;
    rect[1][0] = 11;
    rect[1][1] = 21;
    rect[1][2] = 31;
    rect[1][3] = 41;
    rect[1][4] = 51;
    result = rect[0][0] + rect[0][4] + rect[1][0] + rect[1][4];

    if (result != (10 + 50 + 11 + 51)) return 19;

    /* Test 14: 3D array with strides */
    int32_t arr3d[3][3][3];
    arr3d[2][2][2] = 27;

    if (arr3d[2][2][2] != 27) return 20;

    /* All tests passed */
    return 0;
}
