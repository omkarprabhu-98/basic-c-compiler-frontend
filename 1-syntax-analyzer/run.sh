#!/bin/bash

# exit when any command fails
set -e

yacc -d parser.y
lex scanner.l
cc y.tab.c
./a.out < $1