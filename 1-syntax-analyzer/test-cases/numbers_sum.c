// C program to calculate sum of numbers
#include <stdio.h>
#include <stdbool.h> 

// driver code 
int main() 
{ 
    int sum, times, i;
    sum = 0;
    times = 20;
    for(i = 0; i <= times; i = i + 1) {
        sum = sum + i;
    }
    return 0; 
} 