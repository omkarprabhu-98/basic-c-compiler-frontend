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
%left LOGICAL_AND
%left LOGICAL_OR 
%left '|'
%left '^'
%left '&'
%left EQUALS NOT_EQUAL
%left '>' '<' LESS_THAN_EQUAL_TO GREATER_THAN_EQUAL_TO
%left ">>" "<<" 
%left '+' '-'
%left '*' '/' '%'
%right '!'
%left '(' ')' '[' ']'



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
	| declaration
	;


/* Production rule for functions */
function: 
	type IDENTIFIER '(' argument_list ')' block 
	;

/* Production rule for argument list */
argument_list:
	arguments 
	| 
	;
arguments:
	type IDENTIFIER
	| type IDENTIFIER ',' arguments
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


/* production rule for block of code or scope */
block:
	'{' segments '}'
	;
segments: 
	segments segment
	|
	;


/* production rule for a C segment */
segment: 
	if_segment 
	| for_segment
	| while_segment
	| declaration
	| expression
	| CONTINUE ';'
	| BREAK ';'
	| RETURN HEX_CONST ';'
	| RETURN REAL_CONST ';'
	| RETURN INT_CONST ';'
	;

/* if else-if production */
if_segment: 
	IF '(' arithmetic_expression ')' block 
	| IF '(' arithmetic_expression ')' block ELSE block
	| IF '(' arithmetic_expression ')' block else_if_segment 
	;
else_if_segment:
	ELSE_IF '(' arithmetic_expression ')' block else_ifs ELSE block
	;
else_ifs:
	ELSE_IF '(' arithmetic_expression ')' block else_ifs
	|
	;

/* for segment production */
for_segment:
	FOR '(' expression arithmetic_expression ';' assignment_expression ')' block
	;

/* while segment production */
while_segment:
	WHILE '(' arithmetic_expression ')' block
	;


declaration:
	type IDENTIFIER identifier_lists ';'
	| type array identifier_lists ';'
	;
identifier_lists:
	',' IDENTIFIER identifier_lists
	| ',' array
	|
	;


/*arithmetic expression production rules*/
arithmetic_expression: 
	arithmetic_expression '+' arithmetic_expression
	| arithmetic_expression '-' arithmetic_expression
	| arithmetic_expression '*' arithmetic_expression
	| arithmetic_expression '/' arithmetic_expression
	| arithmetic_expression '^' arithmetic_expression
	| arithmetic_expression '%' arithmetic_expression
	| arithmetic_expression LOGICAL_AND arithmetic_expression
	| arithmetic_expression LOGICAL_OR arithmetic_expression
	| arithmetic_expression '&' arithmetic_expression
	| arithmetic_expression '|' arithmetic_expression
	| '(' arithmetic_expression ')'
	| '!' arithmetic_expression
	| IDENTIFIER
	| HEX_CONST
	| STRING_CONST
	| INT_CONST 
	| REAL_CONST
	| comparison_expression
	;
comparison_expression:
	arithmetic_expression GREATER_THAN_EQUAL_TO arithmetic_expression
	| arithmetic_expression LESS_THAN_EQUAL_TO arithmetic_expression
	| arithmetic_expression EQUALS arithmetic_expression
	| arithmetic_expression NOT_EQUAL arithmetic_expression
	| arithmetic_expression '<' arithmetic_expression
	| arithmetic_expression '>' arithmetic_expression
	;
/*production rules for assignment expression*/
assignment_expression:
	IDENTIFIER '=' arithmetic_expression
	;
expression:
	assignment_expression ';'
	;

array:
	IDENTIFIER '[' INT_CONST ']' square_brackets
	;

square_brackets:
	'[' INT_CONST ']' square_brackets
	|
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