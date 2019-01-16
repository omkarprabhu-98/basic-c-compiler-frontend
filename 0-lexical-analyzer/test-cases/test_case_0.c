#include <stdio.h>

// main function of the program
int main () {
    int a = 2, b = 7;

    /**
     * Various operators
     */
    long c = a ^ b;
    printf("Result: %d ^ %d = %ld", a, b, c);
    int d = a + b;
    printf("Result: %d + %d = %d", a, b, d);
    int e = b / a;
    printf("Result: %d / %d = %d", b, a, e);
    int f = a - b;
    printf("Result: %d - %d = %d", a, b, f);
    int g = a * b;
    printf("Result: %d * %d = %d", a, b, g);
    int h = b % a;
    printf("Result: %d mod %d = %d", b, a, h);

    // Arrays and if with punctuators
    int aa[100];
    aa[0] = 12;
    if (aa[0] == 0) {
        printf("Hello world !=0 ");
    }
    else if (aa[0] != 12) {
        printf("Hello world != 12 ");
    }
    else if (aa[0] <= 1) {
        printf("Hello world <= 1 ");
    }
    else if (aa[0] > 1) {
        printf("Hello world > 1 ");
    }
}