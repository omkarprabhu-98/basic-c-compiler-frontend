%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table.h"

table ** constant_table;

int yylex(void);
void yyerror(char *);
void check_type(int, int);

// links scanner code  
#include "lex.yy.c"

int isFunc = 0;
int isDecl = 0;
int curr_datatype;

int func_return_type;

int flag_args = 0;
char global_args_encoding[500] = {'\0'};
int args_encoding_idx = 0;
%}

%union {
	char * str;
	table * table_ptr;
	int datatype;
};

// TOKEN DECLARATION

%token <str> IDENTIFIER 

// keywords
%token IF ELSE ELSE_IF FOR WHILE CONTINUE BREAK RETURN

// data types
%token INT SHORT LONG_LONG LONG CHAR SIGNED UNSIGNED FLOAT DOUBLE VOID

// logical opertors
%token BITWISE_AND BITWISE_OR LOGICAL_AND LOGICAL_OR LOGICAL_NOT

// relational operators
%token EQUALS LESS_THAN GREATER_THAN NOT_EQUAL LESS_THAN_EQUAL_TO GREATER_THAN_EQUAL_TO

// constants
%token <table_ptr> INT_CONST STRING_CONST HEX_CONST REAL_CONST CHAR_CONST

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

%type <table_ptr> identifier
%type <datatype> arithmetic_expression
%type <datatype> comparison_expression


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
	type		
	identifier	{isDecl = 0; $2->is_func = 1; func_return_type = curr_datatype;}					 
	'(' 		{current_scope_ptr = create_scope(); isFunc = 1;}
	argument_list 
	')' 	{isDecl = 0;}
	block 
	;

/* Production rule for argument list */
argument_list:
	arguments {flag_args = 1;}
	| 
	;
arguments:
	type identifier	
	| type identifier ',' arguments 
	;


/* Production rule for sign or type specifiers */
type: 
	type_specifier	{isDecl = 1;} 
	| sign_specifier type_specifier {isDecl = 1;} 
	;
/* Production rule sign specifiers */
sign_specifier: 
	UNSIGNED
	| SIGNED
	;
/* Production rule data types */
type_specifier: 
	INT	{curr_datatype = INT; if(flag_args == 1) {global_args_encoding[args_encoding_idx++] = 'i'; global_args_encoding[args_encoding_idx++] = '$';}}
	| SHORT {curr_datatype = SHORT; if(flag_args == 1) {global_args_encoding[args_encoding_idx++] = 'i'; global_args_encoding[args_encoding_idx++] = '$';}}
	| LONG_LONG {curr_datatype = LONG_LONG; if(flag_args == 1) {global_args_encoding[args_encoding_idx++] = 'i'; global_args_encoding[args_encoding_idx++] = '$';}}
	| LONG {curr_datatype = LONG; if(flag_args == 1) {global_args_encoding[args_encoding_idx++] = 'i'; global_args_encoding[args_encoding_idx++] = '$';}}
	| CHAR {curr_datatype = CHAR; if(flag_args == 1) {global_args_encoding[args_encoding_idx++] = 'i'; global_args_encoding[args_encoding_idx++] = '$';}}
	| FLOAT {curr_datatype = FLOAT; if(flag_args == 1) {global_args_encoding[args_encoding_idx++] = 'i'; global_args_encoding[args_encoding_idx++] = '$';}}
	| DOUBLE {curr_datatype = DOUBLE; if(flag_args == 1) {global_args_encoding[args_encoding_idx++] = 'i'; global_args_encoding[args_encoding_idx++] = '$';}}
	| VOID {curr_datatype = VOID; if(flag_args == 1) {global_args_encoding[args_encoding_idx++] = 'i'; global_args_encoding[args_encoding_idx++] = '$';}}
	;


/* production rule for block of code or scope */
block:
		'{'		{if (!isFunc) current_scope_ptr =  create_scope(); isFunc = 0;} 
		segments
		'}'		{current_scope_ptr =  exit_scope();}
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
	| func_call
	| declaration
	| expression
	| CONTINUE ';'
	| BREAK ';'
	| RETURN ';' {if (VOID != func_return_type) yyerror("Incorrect return type");}
	| RETURN arithmetic_expression ';'	{if ($2 != func_return_type) yyerror("Incorrect return type");}
	| block
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

/* Function call */ 
func_call:
	identifier '=' identifier '(' parameter_list ')' ';' {if ($3->is_func == 0 || (recursiveSearch(current_scope_ptr, $3->lexeme) == NULL)) yyerror("Invalid function call");}
	| type identifier '=' identifier '(' parameter_list ')' ';' {if ($4->is_func == 0 || (recursiveSearch(current_scope_ptr, $4->lexeme) == NULL)) yyerror("Invalid function call");}
	| identifier '(' parameter_list ')' ';' {if ($1->is_func == 0 || (recursiveSearch(current_scope_ptr, $1->lexeme) == NULL)) yyerror("Invalid function call");}
	;
parameter_list: 
	parameters
	|
	;
parameters: 
	arithmetic_expression ',' parameters
	| arithmetic_expression
	| STRING_CONST ',' parameters
	| STRING_CONST	
	;


/* declaration statements */
declaration:
	type identifier identifier_lists ';' {isDecl = 0;}
	| type array identifier_lists ';'	{isDecl = 0;}
	;
identifier_lists:
	',' identifier identifier_lists
	| ',' array
	|
	;


/*arithmetic expression production rules*/
arithmetic_expression: 
	arithmetic_expression '+' arithmetic_expression	{check_type($1, $3); $$ = $1;}
	| arithmetic_expression '-' arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression '*' arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression '/' arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression '^' arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression '%' arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression LOGICAL_AND arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression LOGICAL_OR arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression '&' arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression '|' arithmetic_expression {check_type($1, $3); $$ = $1;}
	| '(' arithmetic_expression ')'	{$$ = $2;} 
	| '!' arithmetic_expression	{$$ = $2;}
	| identifier	{$$ = $1->data_type;}
	| HEX_CONST		{$$ = $1->data_type;}
	| INT_CONST 	{$$ = $1->data_type;}
	| REAL_CONST	{$$ = $1->data_type;}
	| CHAR_CONST	{$$ = $1->data_type;}
	| comparison_expression {$$ = $1;}
	;
comparison_expression:
	arithmetic_expression GREATER_THAN_EQUAL_TO arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression LESS_THAN_EQUAL_TO arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression EQUALS arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression NOT_EQUAL arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression '<' arithmetic_expression {check_type($1, $3); $$ = $1;}
	| arithmetic_expression '>' arithmetic_expression {check_type($1, $3); $$ = $1;}
	;
/*production rules for assignment expression*/
assignment_expression:
	identifier '=' arithmetic_expression
	;
expression:
	assignment_expression ';'
	;


array:
	identifier '[' INT_CONST ']'	{	
										if (atoi($3->lexeme) < 1) yyerror("Array size less than 1");
										if ($1 != NULL) $1->dimension = atoi($3->lexeme);
									}
	;

identifier: 
	IDENTIFIER	{	if (isDecl) {
						table * ptr = insert(scope_table[current_scope_ptr].header, $1, IDENTIFIER, curr_datatype);
						if (ptr == NULL) {
							yyerror("Redeclaration of a variable");
						}
						$$ = ptr;
					}
					else {
						// $$ = search(scope_table[current_scope_ptr].header, $1);
						$$ = recursiveSearch(current_scope_ptr, $1);
						if($$ == NULL) {
							yyerror("Variable not declared");
						}
					}
				}
	;
%%


int main () {
	init();
	constant_table = create_table();
	scope_table[0].header = create_table();
	scope_table[0].parent = -1;
    yyparse();
    display_scope_table();
	display_const_table(constant_table);
    return 0;
}

void yyerror(char *s) { 
    fprintf(stderr, "Line %d: %s\n", yylineno, s); 
	
}

void check_type(int a, int b) {
	if (a != b) {
		yyerror("Type Mismatch");
	}
}