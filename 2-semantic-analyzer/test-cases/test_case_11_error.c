/**
 * Error in function declaration
 */
#include <stdio.h>

int foo(int x,int y)
{
    return x + y;
}
int main () {
    // no of arguments mismatch error 
	foo(10);

    float id;
    foo(id);

   
}
