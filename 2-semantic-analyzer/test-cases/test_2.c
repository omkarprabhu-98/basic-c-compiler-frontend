/**
 * Error in expression
 */
#include <stdio.h>


int main () {

    // Array subscript present
    int a[10];
    // Array subscript missing
    int b[];
    // Array subscript not an integer
    int c["hello"];

	return 0;
}