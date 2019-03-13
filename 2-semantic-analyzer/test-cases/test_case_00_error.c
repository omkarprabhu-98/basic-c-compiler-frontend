/**
 * Error in ID scope and while type
 */
#include <stdio.h>


int main () {

	// incorrect type in while evaluation
	while (2.33) {
		return 1;
	}

	{	
		int c;
		// variable undeclared
		c = a;
	}
}