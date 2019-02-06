#include <stdio.h>

// global declarations
signed var1;
double var2;


//function without enclosing braces for argument
int addition(int a
{
    int c = a + b;
    return c;
}

//function without return type mentioned -  syntax error
floor_division(int a,int b)
{
    if(b!=0)
    {
        return a/b;
    }
    else
    {
        return 0;
    }
}


//function with wrong identifier naming 
int 12Foo(int x)
{
    printf("This line not executed as wrong identifier naming\n");
}

// main function of the program
int main () {

	int var1 = addition(10,20);
    int var2 = floor_division(20,0);
	
}