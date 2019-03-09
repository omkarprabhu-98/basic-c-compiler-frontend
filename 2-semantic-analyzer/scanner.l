/*================== REQUIRED FILES AND VARIABLES =====================*/
%{
	
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "y.tab.h"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_RESET   "\x1b[0m"



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

/*================== REGULAR EXPRESSION FOR LEXEMS =====================*/
%%

"#"[ ]*"include"[ ]*	{BEGIN HEADERFILESTATE;}
<HEADERFILESTATE>("<"{alphabet}+".h>")(" "*)("\n")	{++yylineno; BEGIN INITIAL;}
<HEADERFILESTATE>(["]{alphabet}+".h"["])(" "*)("\n")	{++yylineno; BEGIN INITIAL;}
<HEADERFILESTATE>.*	{printf(ANSI_COLOR_RED "%d:\t \t\t     : %s\n", yylineno, "Error in header" ANSI_COLOR_RESET); BEGIN INITIAL; yyterminate();}

"#"[ ]*"define"[ ]*	{BEGIN MACROSTATE;}
<MACROSTATE>({alphanumeral}+[ ]+{alphanumeral}+)([ ]*)"\n"	{}
<MACROSTATE>.*	{printf(ANSI_COLOR_RED "%d:\t \t\t     : %s\n", yylineno, "Error in marco" ANSI_COLOR_RESET); BEGIN INITIAL; yyterminate();}


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
"void"			{return VOID;}
"for"			{return FOR;}
"while"			{return WHILE;}
"if"			{return IF;}
"else"			{return ELSE;}
"else if"		{return ELSE_IF;}
"continue"		{return CONTINUE;}
"break"			{return BREAK;}
"return"		{return RETURN;}

{whitespaces}	;


{identifier}		{yylval.str = (char *)malloc(sizeof(yytext));
					strcpy(yylval.str, yytext);  return IDENTIFIER;}


[+\-]?[0][x|X]{hex}+[lLuU]?	{insert(constant_table, yytext, HEX_CONST, 0); return HEX_CONST;}
[+\-]?{digit}+[lLuU]?		{insert(constant_table, yytext, INT_CONST, 0); return INT_CONST;}
[+\-]?{digit}+[.]{digit}+	{insert(constant_table, yytext, REAL_CONST, 0); return REAL_CONST;}

\"([^\n"]*)\"	{insert(constant_table, yytext, STRING_CONST, 0); return STRING_CONST;}


({digit}+)({identifier})	{printf(ANSI_COLOR_RED "%d:\t%-20s : %s\n", yylineno, yytext, "Error in identifier naming" ANSI_COLOR_RESET);}

\n		{++yylineno;}

"&&"	{return LOGICAL_AND;}
"||"	{return LOGICAL_OR;}
"<="	{return LESS_THAN_EQUAL_TO;}
">="	{return GREATER_THAN_EQUAL_TO;}
"=="	{return EQUALS;}
"!="	{return NOT_EQUAL;}

. {return *yytext;}

%%

/*================== MAIN AND OTHER FUNCTIONS =====================*/
int yywrap() {return 1;}