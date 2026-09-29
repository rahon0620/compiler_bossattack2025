%option noyywrap
%{
#include "main.tab.h"
%}
ELEMENT "H"|"C"|"N"|"O"|"Na"|"Cl"|"S"|"Ca"|"Mg"|"Al"
NUMBER [0-9]*
%%
{ELEMENT}   {strcpy(yylval.text, yytext); return ELEMENT;}
{NUMBER}    {yylval.ival = atoi(yytext); return NUMBER;}
"("         {return LPAREM;}
")"         {return RPAREM;}
[ \t\n\r]   {;}
.           {;}

%%