#include <stdio.h>

// main function of the program
int main () {
    int a = 1, b = 2, c;

    /**
     * Various operations
     */
    c = a & b;
    printf("Result BITWISE AND: %d\n", c); 
    c = a | b;
    printf("Result BITWISE OR: %d\n", c);
    c = a && b;
    printf("Result LOGICAL AND: %d\n", c);
    c = a || b;
    printf("Result LOGICAL OR: %d\n", c);
    c = !a;
    printf("Result LOGICAL NOT: %d\n", c);
    c = a >> b;
    printf("Result RIGHT SHIFT: %d\n", c);
    c = a << b;
    printf("Result LEFT SHIFT: %d\n", c);

    /**
     * Various constants
     */

    int d = 10;
    unsigned char e = 0x64;
    float f = 5.0;
}