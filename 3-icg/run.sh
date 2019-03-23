#!/bin/bash

# exit when any command fails
set -e

yacc -d -v parser.y
lex scanner.l
# g++ -std=c++11 y.tab.c
g++ -std=c++11 -g y.tab.c -ly -ll 
./a.out < $1