%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int weight = 0;
void yyerror(const char *message);
int yylex();

int table(char ele[]) {
    if (strcmp(ele, "H") == 0) {
        return 1;
    } else if (strcmp(ele, "C") == 0) {
        return 12;
    } else if (strcmp(ele, "N") == 0) {
        return 14;
    } else if (strcmp(ele, "O") == 0) {
        return 16;
    } else if (strcmp(ele, "Na") == 0) {
        return 23;
    } else if (strcmp(ele, "Cl") == 0) {
        return 35;
    } else if (strcmp(ele, "S") == 0) {
        return 32;
    } else if (strcmp(ele, "Ca") == 0) {
        return 40;
    } else if (strcmp(ele, "Mg") == 0) {
        return 24;
    } else if (strcmp(ele, "Al") == 0) {
        return 27;
    }
}

%}

%union {
    int ival;
    char text[20];
}
%token LPAREM RPAREM
%token<ival> NUMBER
%token<text> ELEMENT
%type<ival> Group Unit Formula

%%
Formula :   Group {
            weight = $1;
        }
        ;

Group   :   Unit {
            $$ = $1;
        }  
        |   Group Unit {
            $$ = $1 + $2;
        }
        ;

Unit    :   ELEMENT {
            $$ = table($1);
        }
        |   Unit NUMBER {
            $$ = $1 * $2;
        } 
        |   LPAREM Formula RPAREM {
            $$ = $2;
        }
        ;

%%

void yyerror (const char *message) {
    printf("%s\n", message);
}

int main(int argc, char *argv[]) {
    yyparse();
    printf("Molecular weight = %d", weight);
    return(0);
}