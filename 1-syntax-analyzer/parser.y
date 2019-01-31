%{
#include <stdio.h>
#include <stdlib.h>
#include "table.h"

int yylex(void);
void yyerror(char *);
%}


%union {
    double dval;
    sym_ptr* sp;
    int ival;
}

// TOKEN DECLARATION

// keywords
%token IF ELSE ELSE_IF FOR WHILE CONTINUE BREAK RETURN

// data types
%token INT SHORT LONG_LONG LONG CHAR SIGNED UNSIGNED FLOAT DOUBLE

// logical opertors
%token BITWISE_AND BITWISE_OR LOGICAL_AND LOGICAL_OR LOGICAL_NOT

// relational operators
%token EQUALS LESS_THAN GREATER_THAN NOT_EQUAL LESS_THAN_EQUAL_TO GREATER_THAN_EQUAL_TO


// types

%left ','
%right '='
%left LOGICAL_OR
%left LOGICAL_AND
%left EQUALS NOT_EQUAL
%left LESS_THAN, GREATER_THAN, LESS_THAN_EQUAL_TO GREATER_THAN_EQUAL_TO
%left '+' '-'
%left '*' '/' '%'
%right '!'


%start starter

%%

starter: starter builder 
        | builder
        ;

        

%%

int main () {
    yyparse();
    return 0;
}
