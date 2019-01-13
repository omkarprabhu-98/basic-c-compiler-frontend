%{
#include<stdio.h>
#include "token-types.h"
%}

/* required definitions */
alphabet [A-Za-z]
alphanumeral [A-Za-z0-9]
hex [0-9a-f]
digit [0-9]

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


[+\-]?[0][x|X]{hex}+[lLuU]?	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, HEX_CONST);}
[+\-]?{digit}+[lLuU]?		{printf("%d:\t%-10s : %3d\n", yylineno, yytext, INT_CONST);}
[+\-]?{digit}+[.]{digit}+	{printf("%d:\t%-10s : %3d\n", yylineno, yytext, REAL_CONST);}
\"[^\"\n]*\"				{printf("%d:\t%-10s : %3d\n", yylineno, yytext, STRING_CONST);}

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