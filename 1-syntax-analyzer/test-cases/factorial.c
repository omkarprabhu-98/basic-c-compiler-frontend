// C program to calculate factorial  
#include <stdio.h>
#include <stdbool.h> 

// driver code 
int main() 
{ 
    int fact, ans;
    fact = 10;

    if(fact == 0) { ans = 1; }
    else {
        ans = 1;

        while(1) {

            ans = ans * fact;
            if (fact != 1) {
                fact = fact - 1;
            }
            else {
                break;
            }
        }
    }
    return 0; 
} 