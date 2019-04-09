/**
 * Error in variable declaration
 */
#include <stdio.h>


int main () {
    // int a;
	// {
	// 	a = 1;
    //     //b = 2;
    //     {
    //         int c;
    //     }
	// }
    // //c = 4;

    //duplicate declaration of id
    int a;
    //array dimension less than 0
	int arr1[-1];
    int arr[10];

	// inbound
    arr [9]=2;
	// out of bound
	arr[10] = 2;

	a = arr[1] + 10;
	// access out of bounds
	a = arr[12] + 1;
}