#include <stdio.h>

int main () {

	int a, b, c, d;
	a = 10;
	b = 20;
	c = 10;
	d = 90;

    a = (b > c) + (d < b) * c - a;

	return 0;
}