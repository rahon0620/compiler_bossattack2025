%option noyywrap
%{
#include "main.tab.h"
%}

NUMBER -?[0-9]+(\.[0-9]+)?
%%
"(" {return LPAREN;} 
")" {return RPAREN;} 
"," {return COMMA;}
"f" {return FFUNC;}
"g" {return GFUNC;} 
"h" {return HFUNC;}
"dg/dx" {return DGDX;}
"dg/dy" {return DGDY;}
{NUMBER} {yylval.fval = strtof(yytext, NULL); return NUM;} 
[ \t\n] {;}
.   {return OTHERS;}
%%