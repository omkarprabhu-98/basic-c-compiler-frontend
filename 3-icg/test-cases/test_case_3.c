#include <stdio.h>

int add(int a,int b)
{
    int c;
    c = a + b;
    return c;
}
int compute(int d,int k,int l)
{
    int mult;
    mult = d*k + d*l + d+l*(d-l);
    return mult;
}
int main(){
    int a,b1;
    a = 20;
    b1 = 30;
	int c;
    c = add(a,b1);
    int d;
    d = compute(c+c*c+a,a,b1*b1+a);
	return 0;
}