%{
#include <stdio.h>
#include <stdlib.h>
#include "table.h"

table ** symbol_table;

int yylex(void);
void yyerror(char *);
%}


%union {
    double dval;
    struct table_entry * ptr;
    int ival;
}

// TOKEN DECLARATION

%token IDENTIFIER 

// keywords
%token IF ELSE ELSE_IF FOR WHILE CONTINUE BREAK RETURN

// data types
%token INT SHORT LONG_LONG LONG CHAR SIGNED UNSIGNED FLOAT DOUBLE

// logical opertors
%token BITWISE_AND BITWISE_OR LOGICAL_AND LOGICAL_OR LOGICAL_NOT

// relational operators
%token EQUALS LESS_THAN GREATER_THAN NOT_EQUAL LESS_THAN_EQUAL_TO GREATER_THAN_EQUAL_TO

// constants
%token INT_CONST STRING_CONST HEX_CONST REAL_CONST

// types

%left ','
%right '='
%left LOGICAL_OR
%left LOGICAL_AND
%left EQUALS NOT_EQUAL
%left LESS_THAN GREATER_THAN LESS_THAN_EQUAL_TO GREATER_THAN_EQUAL_TO
%left '+' '-'
%left '*' '/' '%'
%right '!'


%start begin

%%

/* init production */
begin: 
	begin unit 
	| unit
	;
/* unit derives declaration statements and function blocks */
unit: 
	function
	;


/* Production rule for functions */
function: 
	type IDENTIFIER '(' argument_list ')'
	;

/* Production rule for argument list */
argument_list:
	argument type IDENTIFIER
	| 
	;
/* comma separated arguments */
argument: 
	type IDENTIFIER ',' argument
	|
	;



/* Production rule for sign or type specifiers */
type: 
	sign_specifier 
	| type_specifier
	;
/* Production rule sign specifiers */
sign_specifier: 
	UNSIGNED
	| SIGNED
	;
/* Production rule data types */
type_specifier: 
	INT
	| SHORT
	| LONG_LONG
	| LONG
	| CHAR
	| FLOAT
	| DOUBLE
	;


%%

#include "lex.yy.c"

int main () {
	symbol_table = create_table();

    yyparse();
    display(symbol_table);
    return 0;
}

void yyerror(char *s) { 
    fprintf(stderr, "Line %d: %s\n", yylineno, s); 
}