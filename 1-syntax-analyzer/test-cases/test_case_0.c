#include <stdio.h>

// global declarations
unsigned acd;
double dd;

// main function of the program
int main () {

	// global assignment
	dd = 1.23;
	// local
	int a;
	a = 100;
	int b;
	b  = 40;

    /**
     * Various declarations and operators
     */
    long c;
	c = a ^ b;
    int d, e, g, h; 
	d = a + b;
	e = b / a;
	g = a * b;
	h = b % a;

    // Array declarations
    int arr1[100];
	short arr2[100][1100];
	float arr3[100][100][100];
    
    if (a == 0) {
        // printf("Hello world !=0 ");
    }
    else if (b != 12) {
        // printf("Hello world != 12 ");
    }
    else if (c <= 1) {
        // printf("Hello world <= 1 ");
    }
    else {
        // printf("here");
    }

	if (a == 1) {
		// a is eqqul to 1
	}
	
	if (a == 2) {
		// is a 2
	}
	else {
		// otherwise
	}
}