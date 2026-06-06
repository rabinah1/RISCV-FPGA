/* Linked list operations test
 * C patterns: linked list node creation, traversal, modification, deletion
 * Returns: 0 if all tests pass, or test index (1-based) on first failure
 */

#include <stdint.h>

struct Node {
    int32_t data;
    struct Node *next;
};

int32_t main(void)
{
    int32_t result;
    /* Test 1: Create single node */
    struct Node node1;
    node1.data = 10;
    node1.next = 0;

    if (node1.data != 10) return 1;

    if (node1.next != 0) return 2;

    /* Test 2: Create two-node list */
    struct Node node2;
    node2.data = 20;
    node2.next = 0;
    node1.next = &node2;

    if (node1.next->data != 20) return 3;

    /* Test 3: Traverse two-node list */
    struct Node *current = &node1;
    result = current->data;

    if (result != 10) return 4;

    current = current->next;

    if (current->data != 20) return 5;

    if (current->next != 0) return 6;

    /* Test 4: Create three-node list */
    struct Node node3;
    node3.data = 30;
    node3.next = 0;
    node2.next = &node3;
    current = &node1;
    result = 0;

    while (current != 0) {
        result += current->data;
        current = current->next;
    }

    if (result != 60) return 8;

    /* Test 5: Count list length */
    current = &node1;
    int32_t count = 0;

    while (current != 0) {
        count++;
        current = current->next;
    }

    if (count != 3) return 9;

    /* Test 6: Find last node */
    current = &node1;

    while (current->next != 0) {
        current = current->next;
    }

    if (current->data != 30) return 10;

    /* Test 7: Middle node access */
    struct Node *mid = node1.next;

    if (mid->data != 20) return 11;

    /* Test 8: Insert after first node */
    struct Node insert_node;
    insert_node.data = 15;
    insert_node.next = node1.next;
    node1.next = &insert_node;

    /* Verify insertion */
    if (node1.next->data != 15) return 12;

    if (node1.next->next->data != 20) return 13;

    /* Test 9: Traverse after insertion */
    current = &node1;
    result = 0;
    count = 0;

    while (current != 0) {
        result += current->data;
        count++;
        current = current->next;
    }

    if (result != 75) return 14;

    if (count != 4) return 15;

    /* Test 10: Array of linked list heads */
    struct Node list1, list2;
    list1.data = 100;
    list1.next = 0;
    list2.data = 200;
    list2.next = 0;
    struct Node *heads[2];
    heads[0] = &list1;
    heads[1] = &list2;

    if (heads[0]->data != 100) return 16;

    if (heads[1]->data != 200) return 17;

    /* Test 11: Traverse multiple lists */
    result = 0;
    int32_t i;

    for (i = 0; i < 2; i++) {
        current = heads[i];
        result += current->data;
    }

    if (result != 300) return 18;

    /* Test 12: List with sentinel/dummy node */
    struct Node dummy;
    dummy.data = 0;
    dummy.next = &list1;
    current = &dummy;
    count = 0;

    while (current->next != 0) {
        count++;
        current = current->next;
    }

    if (count != 1) return 19;

    /* Test 13: Deep traversal (follow chain multiple times) */
    current = &node1;
    int32_t found = 0;

    while (current != 0) {
        if (current->data == 15) {
            found = 1;
        }

        current = current->next;
    }

    if (found != 1) return 20;

    /* All tests passed */
    return 0;
}
