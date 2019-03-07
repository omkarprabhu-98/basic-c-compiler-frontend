#include <stdio.h>
#include "table.h"
int main() {
    scope_table[0].header = create_table();
    insert(scope_table[current_scope_ptr].header, "one", 23);
    display_scope_table();
    return 0;
}