#!/bin/bash

# exit when any command fails
set -e

# compile and run
lex scanner.l
cc lex.yy.c
./a.out < $1
