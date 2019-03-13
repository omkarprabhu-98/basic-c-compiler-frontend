/**
 * Error in expression
 */
#include <stdio.h>

int main () {
	{
		int a;
		{
			a = 20;
		}
	}
	{
		// Undeclared
		a = 10;
	}
	return 0;
}