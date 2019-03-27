#include <stdio.h>

int main () {
	{
        int a, b, c, d;
        a = 60;
        b = 20;
        c = 10;
        d = 90;

        {
            int x, y;
            a = (b > c) + (d < b) * c - a / (b > c) + (d < b) * c - a;
            x = (b + a) / (a < b) * b + a / (b > c) + (d < b) * c - a;
            y = x + a;
        }
        {
            // Uncomment
            // x and y not declared (out of scope)
            // a = x + y;
        }
    }
	return 0;
}