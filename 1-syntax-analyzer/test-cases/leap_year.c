// C program to check if a given  
// year is leap year or not 
#include <stdio.h>
#include <stdbool.h> 
  
int checkYear(int year) 
{ 
    // If a year is multiple of 400,  
    // then it is a leap year 
    if (year % 400 == 0) {
        return 1; 
	}
  
    // Else If a year is muliplt of 100, 
    // then it is not a leap year 
    if (year % 100 == 0) {
        return 0; 
	}
  
    // Else If a year is muliplt of 4, 
    // then it is a leap year 
    if (year % 4 == 0) { 
        return 1; 
	}
    return 0; 
} 
  
// driver code 
int main() 
{ 
    int year;
	year = 2000; 
	checkYear(year);

    return 0; 
} 