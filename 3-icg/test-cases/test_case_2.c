#include <stdio.h>

int main(){
    int a,b1;
    a = 20;
    b1 = 30;
	{
        int a1;
        a1 = -1;
        int b1;
        b1 = a1*a1 + b1+a1;
    }

    int c,d,e,f;

    c = d*e + f*f*e*d*e;
    c = 2*c;
    f = (d<e);

	return 0;
}