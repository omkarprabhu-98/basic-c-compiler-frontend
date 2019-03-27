#include <stdio.h>

int main () {

	int a, b, c, d;
	a = 10;
	b = 20;
	c = 10;
	d = 90;

	if (a + b > 90) {
		c = c + d;
	}
	else if (b > c) {
		if (a + d > 0) {
			a = 90;
		}
	}
	else {
		c = 100;
	}
	
	int e;
	e = d + a;

	return 0;
}