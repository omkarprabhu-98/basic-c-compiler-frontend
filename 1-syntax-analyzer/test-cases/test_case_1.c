#include<stdio.h>

// global declarations
signed var1;
double var2;

void func() {
    return;
}

int foo()
{
    return 10;
}
int addition(int a,int b)
{
    int c;
    c = a + b;
    return c;
}

int floor_division(int a,int b)
{
    if(b!=0)
    {
        int j;
        j = a/b;
        return j;
    }
    else
    {
        return 0;
    }
}
// main function of the program
int main () {

    int x;
    x = 10;
    int y;
    y = 20;
    int var1 = addition(x,y);
    int var2 = floor_division(x,y);

    int var3 = foo();	
}