/*================== REQUIRED FILES AND VARIABLES =====================*/
%{
	
#include <stdio.h>
#include<string.h>
#include<stdlib.h>
#include "y.tab.h"

#define ANSI_COLOR_RED     "\x1b[31m"
// #define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_RESET   "\x1b[0m"
// #define ANSI_COLOR_BLUE    "\x1b[34m"
// #define ANSI_COLOR_YELLOW  "\x1b[33m"


// #include "token-types.h"
// #include "table.h"

// int flagTernary = 0;
// int ternaryCount = 0;

%}

/*================== OTHER DEFINITIONS =====================*/
/* required definitions */
alphabet [A-Za-z]
alphanumeral [A-Za-z0-9]
hex [0-9a-f]
digit [0-9]
identifier ({alphabet}|_)({alphabet}|{digit}|_){0,31}
whitespaces  [ \t\r\f\v]+

/* Exclusive states */
%x HEADERFILESTATE
%x MACROSTATE
%x MULCOMMENTSTATE
%x TERNARYSTATE
%x STRINGCONSTSTATE

/*================== REGULAR EXPRESSION FOR LEXEMS =====================*/
%%

"#"[ ]*"include"[ ]*	{BEGIN HEADERFILESTATE;}
<HEADERFILESTATE>("<"{alphabet}+".h>")(" "*)("\n")	{++yylineno; BEGIN INITIAL;}
<HEADERFILESTATE>(["]{alphabet}+".h"["])(" "*)("\n")	{++yylineno; BEGIN INITIAL;}
<HEADERFILESTATE>.*	{printf(ANSI_COLOR_RED "%d:\t \t\t     : %s\n", yylineno, "Error in header" ANSI_COLOR_RESET); BEGIN INITIAL;}

"#"[ ]*"define"[ ]*	{BEGIN MACROSTATE;}
<MACROSTATE>({alphanumeral}+[ ]+{alphanumeral}+)([ ]*)"\n"	{}
<MACROSTATE>.*	{printf(ANSI_COLOR_RED "%d:\t \t\t     : %s\n", yylineno, "Error in marco" ANSI_COLOR_RESET); BEGIN INITIAL;}


"//".*"\n"?	{++yylineno;}

"/*"	{BEGIN MULCOMMENTSTATE;}
<MULCOMMENTSTATE>("\n")	{++yylineno;}
<MULCOMMENTSTATE>(.)	;
<MULCOMMENTSTATE>"/*"	{printf(ANSI_COLOR_RED "%d:\t \t\t     : %s\n", yylineno, "Error nested multiline comments" ANSI_COLOR_RESET); BEGIN INITIAL;}
<MULCOMMENTSTATE>"*/"	{BEGIN INITIAL;}


"int"			{return INT;}
"long"			{return LONG;}
"short"			{return SHORT;}
"long long"		{return LONG_LONG;}
"char"			{return CHAR;}
"signed"		{return SIGNED;}
"unsigned"		{return UNSIGNED;}
"float"			{return FLOAT;}
"double"		{return DOUBLE;}
"for"			{return FOR;}
"while"			{return WHILE;}
"if"			{return IF;}
"else"			{return ELSE;}
"else if"		{return ELSE_IF;}
"continue"		{return CONTINUE;}
"break"			{return BREAK;}
"return"		{return RETURN;}

{whitespaces}	;


({identifier})		{yylval.ptr = insert(yytext, IDENTIFIER); 
					return IDENTIFIER;}


[+\-]?[0][x|X]{hex}+[lLuU]?	{return HEX_CONST;}
[+\-]?{digit}+[lLuU]?		{return INT_CONST;}
[+\-]?{digit}+[.]{digit}+	{return REAL_CONST;}

\"							{BEGIN STRINGCONSTSTATE;}
<STRINGCONSTSTATE>\"		{return STRING_CONST; BEGIN INITIAL;}
<STRINGCONSTSTATE>\n		{printf(ANSI_COLOR_RED "%d:\t \t\t     : %s\n", yylineno, "Error in string constant" ANSI_COLOR_RESET); ++yylineno; BEGIN INITIAL;}
<STRINGCONSTSTATE>.			;

({digit}+)({identifier})	{printf(ANSI_COLOR_RED "%d:\t%-20s : %s\n", yylineno, yytext, "Error in identifier naming" ANSI_COLOR_RESET);}

\n		{++yylineno;}



%%

/*================== MAIN AND OTHER FUNCTIONS =====================*/
int yywrap() {return 1;}

int main() {
	yylex();	
	return 0;
}