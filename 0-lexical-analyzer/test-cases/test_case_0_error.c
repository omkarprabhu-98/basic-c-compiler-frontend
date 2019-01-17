#include <stdio>

// main function of the program
int main () {
    int x;

    //ternary check
    x = 2 > 5 != 1 ? 5 < 8 && 8 > 2 ? !5 ? 10 : 20 : 30 : 40;
    //ternary check ends


    x = 5 > 8 ? 10 : 1 != 2 < 5 ? 20 : 30; 


    //ternary with errors below
    x = 5 > 8 ? 10 : 1 != 2 < 5 ? 20 : 30 :;

    x = 5 > 8 ? 10 ? 1 != 2 < 5 ? 20 : 30; 

    int a @ 12;
}