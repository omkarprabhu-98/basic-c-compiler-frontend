%{
#include <bits/stdc++.h>
#include "table.h"
#include "icg.h"

table ** constant_table;

using namespace std;

int yylex(void);
void yyerror(string);
void check_type(int, int);
void append_global_args_encoding(char);
char mapper_datatype(int);
char *string_rev(char *);


// links scanner code  
#include "lex.yy.c"

int isFunc = 0;
int isDecl = 0;
int curr_datatype;
int isFor = 0;

int func_return_type;

int flag_args = 0;
char global_args_encoding[500] = {'\0'};
int args_encoding_idx = 0;

stack <int> for_stack;
stack <int> break_position;
stack <int> continue_position;

%}

%union {
	char * str;
	table * table_ptr;
	// int datatype;
	icg_container* icg_ptr;
	int curr_inst;
};

// TOKEN DECLARATION

%token <str> IDENTIFIER 

// keywords
%token IF ELSE ELSE_IF
%token <curr_inst> FOR
%token WHILE CONTINUE BREAK RETURN

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
%type <icg_ptr> arithmetic_expression
%type <icg_ptr> comparison_expression
%type <icg_ptr> assignment_expression
%type <curr_inst> if_push_curr_instr
%type <curr_inst> block;
%type <curr_inst> elseif_push_curr_instr
%type <curr_inst> while_push_curr_instr


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
	identifier	{
					isDecl = 0; $2->is_func = 1; func_return_type = curr_datatype;
    				push_3addr_code_instruction(string($2->lexeme) + ":");
				}					 
	'(' 		{current_scope_ptr = create_scope(); isFunc = 1; flag_args = 1; args_encoding_idx = 0; global_args_encoding[args_encoding_idx++] = '$';}
	argument_list
	')' 	{isDecl = 0; if (args_encoding_idx > 1) {global_args_encoding[args_encoding_idx++] = '\0'; insert_args_encoding($2, global_args_encoding); args_encoding_idx = 0; flag_args = 0;}}
	block 
	;

/* Production rule for argument list */
argument_list:
	arguments 
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
	INT	{curr_datatype = INT; append_global_args_encoding('i');}
	| SHORT {curr_datatype = SHORT; append_global_args_encoding('s');}
	| LONG_LONG {curr_datatype = LONG_LONG; append_global_args_encoding('L');}
	| LONG {curr_datatype = LONG; append_global_args_encoding('l');}
	| CHAR {curr_datatype = CHAR; append_global_args_encoding('i');}
	| FLOAT {curr_datatype = FLOAT; append_global_args_encoding('f');}
	| DOUBLE {curr_datatype = DOUBLE; append_global_args_encoding('d');}
	| VOID {curr_datatype = VOID; append_global_args_encoding('v');}
	;


/* production rule for block of code or scope */
block:
		'{'		{if (!isFunc) current_scope_ptr =  create_scope(); isFunc = 0;} 
		segments
		'}'		{
					current_scope_ptr =  exit_scope();//adding here
					$$ = next_instr_count;
				}
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
	| CONTINUE ';'	{
						if( !continue_position.empty() )
						{
							push_3addr_code_instruction("goto " + to_string(continue_position.top()-1));
							continue_position.pop();	
						}
						else{
							yyerror("ERROR: Continue must be used in a loop");
						}
					}
	| BREAK ';'	{
					push_3addr_code_instruction("goto _");
					break_position.push(next_instr_count);
				}
	| RETURN ';' {if (VOID != func_return_type) yyerror("Incorrect return type");
					push_3addr_code_instruction("return");
				}
	| RETURN arithmetic_expression ';'	{
											if ($2->datatype != func_return_type) yyerror("Incorrect return type");
											push_3addr_code_instruction("return " + string($2->temp_var));
										}
	| block
	;



/* if else-if production */
if_segment: 
	if_push_curr_instr block {backpatch($1, next_instr_count);}
	| if_push_curr_instr block {push_3addr_code_instruction("goto _"); backpatch($1, next_instr_count);} else_if_segment {backpatch($2, next_instr_count);}
	;

else_if_segment:
	elseif_push_curr_instr block {push_3addr_code_instruction("goto _"); backpatch($1,next_instr_count);} else_if_segment {backpatch($2, next_instr_count);}
	| ELSE block 
	;
elseif_push_curr_instr: 
	ELSE_IF '(' arithmetic_expression ')' {$$ = next_instr_count; push_3addr_code_instruction("if not "+ $3->temp_var + " goto _");}
	;

if_push_curr_instr: 
	IF '(' arithmetic_expression ')' {$$ = next_instr_count; push_3addr_code_instruction("if not "+ $3->temp_var + " goto _");}
	;



/* for segment production */
for_segment:
	FOR '(' expression {$1 = next_instr_count;} 
	
	arithmetic_expression ';' {check_type($5->datatype, INT); for_stack.push(next_instr_count); push_3addr_code_instruction("if not " + $5->temp_var + " goto _"); isFor = 1;} 
	
	assignment_expression ')' {isFor = 0;}
	
	block {backpatch_for_increment($8->child_instructions); push_3addr_code_instruction("goto " + to_string($1)); backpatch(for_stack.top(), next_instr_count); for_stack.pop();}
	;



/* while segment production */
while_segment:
	while_push_curr_instr block {
									backpatch($1, next_instr_count); 
									push_3addr_code_instruction("goto " + to_string($1-1));
									if( !break_position.empty() ){
										backpatch(break_position.top()-1, next_instr_count);
										break_position.pop();
									}
								}
	;
while_push_curr_instr:
	WHILE '(' arithmetic_expression ')' {
											$$ = next_instr_count; 
											push_3addr_code_instruction("if not "+ $3->temp_var + " goto _");
											continue_position.push(next_instr_count);
										}
	;



/* Function call */ 
func_call:
	identifier '=' identifier '(' parameter_list ')' ';' {if ($3->is_func == 0 || (recursiveSearch(current_scope_ptr, $3->lexeme) == NULL)) yyerror("Invalid function call");}
	| type identifier '=' identifier '(' parameter_list ')' ';' {if ($4->is_func == 0 || (recursiveSearch(current_scope_ptr, $4->lexeme) == NULL)) yyerror("Invalid function call");}
	| identifier 
		'('	{flag_args = 1; args_encoding_idx = 0; global_args_encoding[args_encoding_idx++] = '$';} 
		parameter_list
		')' 
		';' {	table *ptr = recursiveSearch(current_scope_ptr, $1->lexeme);
				if (args_encoding_idx > 1) {global_args_encoding[args_encoding_idx++] = '\0'; flag_args = 0;}
				// printf("\n\n\n%s\n\n\n", global_args_encoding);
				if ($1->is_func == 0 || (ptr == NULL)) {
					yyerror("Invalid function call");
				}
				else if (ptr->args_encoding == NULL && args_encoding_idx == 1) { 
				} 
				else if (strcmp(ptr->args_encoding, string_rev(global_args_encoding)) != 0) {
					yyerror("Invalid function call, Arguments mismatch");
				}	
			}
	;
parameter_list: 
	parameters
	|
	;
parameters: 
	arithmetic_expression ',' parameters {append_global_args_encoding(mapper_datatype($1->datatype));}
	| arithmetic_expression {append_global_args_encoding(mapper_datatype($1->datatype));}
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
	arithmetic_expression '+' arithmetic_expression	{
														check_type($1->datatype, $3->datatype); 
														$$ = new icg_container();
														$$->datatype = $1->datatype;
														gen_3addr_code_arithmetic($$, $1, $3, " + ", isFor);
													}
	| arithmetic_expression '-' arithmetic_expression {
														check_type($1->datatype, $3->datatype); 
														$$ = new icg_container();
														$$->datatype = $1->datatype;
														gen_3addr_code_arithmetic($$, $1, $3, " - ", isFor);
													}
	| arithmetic_expression '*' arithmetic_expression {
														check_type($1->datatype, $3->datatype); 
														$$ = new icg_container();
														$$->datatype = $1->datatype;
														gen_3addr_code_arithmetic($$, $1, $3, " * ", isFor);
													}
	| arithmetic_expression '/' arithmetic_expression {
														check_type($1->datatype, $3->datatype); 
														$$ = new icg_container();
														$$->datatype = $1->datatype;
														gen_3addr_code_arithmetic($$, $1, $3, " / ", isFor);
													}
	| arithmetic_expression '^' arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression '%' arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression LOGICAL_AND arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression LOGICAL_OR arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression '&' arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression '|' arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| '(' arithmetic_expression ')'	{$$ = $2;} 
	| '!' arithmetic_expression	{$$ = $2;}
	| identifier	{$$ = new icg_container(); $$->datatype = $1->data_type; $$->temp_var = $1->lexeme;}
	| HEX_CONST		{$$ = new icg_container(); $$->datatype = $1->data_type; $$->temp_var = $1->lexeme;}
	| INT_CONST 	{$$ = new icg_container(); $$->datatype = $1->data_type; $$->temp_var = $1->lexeme;}
	| REAL_CONST	{$$ = new icg_container(); $$->datatype = $1->data_type; $$->temp_var = $1->lexeme;}
	| CHAR_CONST	{$$ = new icg_container(); $$->datatype = $1->data_type; $$->temp_var = $1->lexeme;}
	| comparison_expression {$$ = $1;}
	;
comparison_expression:
	arithmetic_expression GREATER_THAN_EQUAL_TO arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression LESS_THAN_EQUAL_TO arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression EQUALS arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression NOT_EQUAL arithmetic_expression {check_type($1->datatype, $3->datatype); $$ = $1;}
	| arithmetic_expression '<' arithmetic_expression {
														check_type($1->datatype, $3->datatype); 
														$$ = new icg_container();
														$$->datatype = $1->datatype;
														gen_3addr_code_arithmetic($$, $1, $3, " < ", isFor);
													}
	| arithmetic_expression '>' arithmetic_expression {
														check_type($1->datatype, $3->datatype); 
														$$ = new icg_container();
														$$->datatype = $1->datatype;
														gen_3addr_code_arithmetic($$, $1, $3, " > ", isFor);
													}
	;
/*production rules for assignment expression*/
assignment_expression:
	identifier '=' arithmetic_expression {	
											$$ = new icg_container();
											$$->temp_var = $1->lexeme;
											gen_3addr_code_assignment($$, $3, isFor);
										}
	| identifier '[' INT_CONST ']' '=' arithmetic_expression {if ($1->dimension != 0 && ($1->dimension <= atoi($3->lexeme)|| atoi($3->lexeme) < 0)) {yyerror("Out of bounds");}}
	;
expression:
	assignment_expression ';'
	;




array:
	identifier '[' INT_CONST ']'	{	if (isDecl) {
											if (atoi($3->lexeme) < 1) yyerror("Array size less than 1");
											if ($1 != NULL) $1->dimension = atoi($3->lexeme);
										}
									}
	;



identifier: 
	IDENTIFIER	{	if (isDecl) {
						table * ptr = insert(scope_table[current_scope_ptr].header, $1, IDENTIFIER, curr_datatype);
						if (ptr == NULL) {
							yyerror("Redeclaration of a variable");
							exit(0);
						}
						else {
							$$ = ptr;
						}
						
					}
					else {
						// $$ = search(scope_table[current_scope_ptr].header, $1);
						$$ = recursiveSearch(current_scope_ptr, $1);
						if($$ == NULL) {
							yyerror("Variable not declared");
							exit(0);
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
	generate_intermediate_code();

    return 0;
}

void yyerror(string s) { 
    //fprintf(stderr, "Line %d: %s\n", yylineno, s); 
	cerr << "Line: " << yylineno << " " << s << endl;
}

void check_type(int a, int b) {
	if (a != b) {
		yyerror("Type Mismatch");
	}
}

void append_global_args_encoding(char i) {
	if(flag_args == 1) {
		global_args_encoding[args_encoding_idx++] = i;
		global_args_encoding[args_encoding_idx++] = '$';
	}
}

char mapper_datatype(int datatype) {
	switch(datatype) {
		case INT:
			return 'i';
		case SHORT:
			return 's';
		case LONG_LONG:
			return 'L';
		case LONG:
			return 'l';
		case CHAR:
			return 'i';
		case FLOAT:
			return 'f';
		case DOUBLE:
			return 'd';
		case VOID:
			return 'v';
	}
}

char *string_rev(char *str)
{
      char *p1, *p2;

      if (! str || ! *str)
            return str;
      for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2)
      {
            *p1 ^= *p2;
            *p2 ^= *p1;
            *p1 ^= *p2;
      }
      return str;
}