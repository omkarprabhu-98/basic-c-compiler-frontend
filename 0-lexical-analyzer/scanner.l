%{
#include <stdio.h>
#include "token-types.h"
%}

/* required definitions */
alphabet [A-Za-z]
alphanumeral [A-Za-z0-9]

/* Exclusive states */
%x HEADERFILESTATE
%x MACROSTATE
%x MULCOMMENTSTATE

%%

"#"[ ]*"include"[ ]*	{BEGIN HEADERFILESTATE;}
<HEADERFILESTATE>("<"{alphabet}+".h>")("\r\n"*)	{printf("Preprocessor-header-file: Header file with <>\n"); BEGIN INITIAL;}
<HEADERFILESTATE>(["]{alphabet}+".h"["])("\r\n"*)	{printf("Preprocessor-header-file: Header file with \"\"\n"); BEGIN INITIAL;}
<HEADERFILESTATE>.*	{printf("Preprocessor-header-file: Error\n"); BEGIN INITIAL;}

"#"[ ]*"define"[ ]*	{BEGIN MACROSTATE;}
<MACROSTATE>({alphanumeral}+[ ]+{alphanumeral}+)([ ]*)"\n"	{printf("Preprocessor-macros: Correct Macro\n");}
<MACROSTATE>.*	{printf("Preprocessor-macros: Error\n"); BEGIN INITIAL;}


"//".*"\n"?	{printf("Comment: Single line\n");}

"/*"	{printf("Comment: Multiline comment begins\n"); BEGIN MULCOMMENTSTATE;}
<MULCOMMENTSTATE>("\n"|.)	;
<MULCOMMENTSTATE>"/*"	{printf("Comment: Error Nested Multiline comment\n"); BEGIN INITIAL;}
<MULCOMMENTSTATE>"*/"	{printf("Comment: Multiline comment ends"); BEGIN INITIAL;}

\n		{yylineno++;}

"++"	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, INCREMENT);}
"--"	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, DECREMENT);}
"-"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, SUBTRACTION);}
"+"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, ADDITION);}
"*"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, MULTIPLICATION);}
"/"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, DIVISION);}
"%"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, MODULO);}
"^"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, POWER);}

"=="	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, EQUALS);}
"<="	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, LESS_THAN_EQUAL_TO);}
">="	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, GREATER_THAN_EQUAL_TO);}
"<"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, LESS_THAN);}
">"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, GREATER_THAN);}
"!="	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, NOT_EQUAL);}

"="		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, ASSIGN);}

"&&"	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, LOGICAL_AND);}
"||"	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, LOGICAL_OR);}
"&"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, BITWISE_AND);}
"|"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, BITWISE_OR);}
"!"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, LOGICAL_NOT);}

"<<"	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, LEFT_SHIFT);}
">>"	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, RIGHT_SHIFT);}


";"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, SEMICOLON);}
","		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, COMMA);}
"{" 	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, O_BRACES);}
"}" 	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, C_BRACES);}
"("		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, O_PARENTHESES);}
")"		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, C_PARENTHESES);}
"[" 	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, O_BRACKETS);}
"]" 	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, C_BRACKETS);}

.   	;


%%

int yywrap() {return 1;}

int main() {
	yylex();	
	return 0;
}


/*
For windows ENTER is "\r\n" CLRF
Others "\n" RF

*/