/**
 * Error in Function calls and return types
 */
#include <stdio.h>

void func(double a, float b, char x) {

}

int main () {
	int a;
	// ID is not a function
	a();

	double aa;
	float bb;
	char c;
	// Argument of different type
	func(aa, bb, 2.3);
	// Number of arguments don't match
	func(aa, bb);

	// Incorrect return type
	return 2.1313;
}