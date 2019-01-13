%{
#include <stdio.h>
#include "token-types.h"
%}

/* required definitions */
alphabet [A-Za-z]
alphanumeral [A-Za-z0-9]
hex [0-9a-f]
digit [0-9]
identifier ({alphabet}|_)({alphabet}|{digit}|_){0,31}

/* Exclusive states */
%x HEADERFILESTATE
%x MACROSTATE
%x MULCOMMENTSTATE
%x IDENTIFIERSTATE

%%

"#"[ ]*"include"[ ]*	{BEGIN HEADERFILESTATE;}
<HEADERFILESTATE>("<"{alphabet}+".h>")("\r\n")	{printf("Preprocessor-header-file: Header file with <>\n"); yylineno++; BEGIN INITIAL;}
<HEADERFILESTATE>(["]{alphabet}+".h"["])("\r\n")	{printf("Preprocessor-header-file: Header file with \"\"\n"); yylineno++; BEGIN INITIAL;}
<HEADERFILESTATE>.*	{printf("Preprocessor-header-file: Error\n"); BEGIN INITIAL;}

"#"[ ]*"define"[ ]*	{BEGIN MACROSTATE;}
<MACROSTATE>({alphanumeral}+[ ]+{alphanumeral}+)([ ]*)"\n"	{printf("Preprocessor-macros: Correct Macro\n");}
<MACROSTATE>.*	{printf("Preprocessor-macros: Error\n"); BEGIN INITIAL;}


"//".*"\n"?	{printf("Comment: Single line\n");}

"/*"	{printf("Comment: Multiline comment begins\n"); BEGIN MULCOMMENTSTATE;}
<MULCOMMENTSTATE>("\n"|.)	;
<MULCOMMENTSTATE>"/*"	{printf("Comment: Error Nested Multiline comment\n"); BEGIN INITIAL;}
<MULCOMMENTSTATE>"*/"	{printf("Comment: Multiline comment ends"); BEGIN INITIAL;}


"int"			{printf("Identified INT\n");BEGIN IDENTIFIERSTATE;}
"long"			{printf("Identified LONG\n");BEGIN IDENTIFIERSTATE;}
"short"			{printf("Identified SHORT\n");BEGIN IDENTIFIERSTATE;}
"long long"		{printf("Identified LONG LONG\n");BEGIN IDENTIFIERSTATE;}
"char"			{printf("Identified CHAR\n");BEGIN IDENTIFIERSTATE;}
"signed"		{printf("Identified SIGNED\n");BEGIN IDENTIFIERSTATE;}
"unsigned"		{printf("Identified UNSIGNED\n");BEGIN IDENTIFIERSTATE;}
"float"			{printf("Identified FLOAT\n");BEGIN IDENTIFIERSTATE;}
"double"		{printf("Identified DOUBLE\n");BEGIN IDENTIFIERSTATE;}
"for"			{printf("Identified FOR\n");}
"if"			{printf("Identified IF\n");}
"else"			{printf("Identified ELSE\n");}
"continue"		{printf("Identified CONTINUE\n");}
"break"			{printf("Identified BREAK\n");}
"return"		{printf("Identified RETURN\n");}

<IDENTIFIERSTATE>([ ]*)     ;
<IDENTIFIERSTATE>({identifier}) {printf("Identified the identifier: //%s//\n",yytext);BEGIN INITIAL;}
<IDENTIFIERSTATE>({digit})      {printf("Error in identifier naming\n"); BEGIN INITIAL;}
({digit}+)({identifier})              {printf("Error in identifier naming\n");}
({identifier})                        {printf("Identified the identifier1: //%s//\n",yytext);}


[+\-]?[0][x|X]{hex}+[lLuU]?	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, HEX_CONST);}
[+\-]?{digit}+[lLuU]?		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, INT_CONST);}
[+\-]?{digit}+[.]{digit}+	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, REAL_CONST);}
\"[^\"\n]*\"				{printf("%d:\t%-10s : %3d\n", yylineno, yytext, STRING_CONST);}


\n		{yylineno++;}

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