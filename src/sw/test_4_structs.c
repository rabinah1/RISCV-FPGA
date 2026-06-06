/* Struct and composition test
 * C patterns: structs with multiple fields, nested structs, arrays of structs
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

struct Point {
    int32_t x;
    int32_t y;
};

struct Rectangle {
    struct Point top_left;
    struct Point bottom_right;
};

struct Person {
    int32_t age;
    int32_t height;
    int32_t weight;
};

struct Company {
    struct Person employees[3];
    int32_t num_employees;
};

int32_t main(void)
{
    int32_t result;
    /* Test 1: Simple struct, field access */
    struct Point p1;
    p1.x = 10;
    p1.y = 20;

    if (p1.x != 10) return 1;

    if (p1.y != 20) return 2;

    /* Test 2: Struct field computation */
    result = p1.x + p1.y;

    if (result != 30) return 3;

    /* Test 3: Multiple struct instances */
    struct Point p2;
    p2.x = 100;
    p2.y = 200;
    result = p2.x - p1.x;

    if (result != 90) return 4;

    /* Test 4: Nested struct - Rectangle contains two Points */
    struct Rectangle rect;
    rect.top_left.x = 0;
    rect.top_left.y = 100;
    rect.bottom_right.x = 50;
    rect.bottom_right.y = 0;

    if (rect.top_left.x != 0) return 5;

    if (rect.bottom_right.x != 50) return 6;

    /* Test 5: Nested struct - compute properties */
    int32_t width = rect.bottom_right.x - rect.top_left.x;
    int32_t height = rect.top_left.y - rect.bottom_right.y;

    if (width != 50) return 7;

    if (height != 100) return 8;

    /* Test 6: Array of structs */
    struct Point points[3];
    points[0].x = 10;
    points[0].y = 20;
    points[1].x = 30;
    points[1].y = 40;
    points[2].x = 50;
    points[2].y = 60;

    if (points[1].x != 30) return 9;

    if (points[2].y != 60) return 10;

    /* Test 7: Iteration over array of structs */
    result = 0;
    int32_t i;

    for (i = 0; i < 3; i++) {
        result += points[i].x;
    }

    if (result != (10 + 30 + 50)) return 11;

    /* Test 8: Struct with multiple int fields */
    struct Person person;
    person.age = 30;
    person.height = 180;
    person.weight = 75;

    if (person.age != 30) return 12;

    if (person.height != 180) return 13;

    if (person.weight != 75) return 14;

    /* Test 9: Array of complex structs (Company with employees) */
    struct Company company;
    company.num_employees = 2;
    company.employees[0].age = 25;
    company.employees[0].height = 170;
    company.employees[1].age = 35;
    company.employees[1].height = 180;

    if (company.employees[0].age != 25) return 15;

    if (company.employees[1].height != 180) return 16;

    /* Test 10: Pointer to struct */
    struct Point *p_ptr = &p1;

    if (p_ptr->x != 10) return 17;

    if (p_ptr->y != 20) return 18;

    /* Test 11: Pointer to struct field modification */
    p_ptr->x = 999;

    if (p1.x != 999) return 19;

    /* Test 12: Pointer to nested struct */
    struct Rectangle *r_ptr = &rect;

    if (r_ptr->top_left.x != 0) return 20;

    if (r_ptr->bottom_right.y != 0) return 21;

    /* Test 13: Array of structs via pointer */
    struct Point *pts_ptr = points;

    if (pts_ptr[0].x != 10) return 22;

    if (pts_ptr[2].y != 60) return 23;

    /* Test 14: Computation with struct fields from array */
    result = company.employees[0].age + company.employees[1].age;

    if (result != 60) return 24;

    /* All tests passed */
    return 0;
}
