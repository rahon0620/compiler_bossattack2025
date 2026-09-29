%{
//#define YYDEBUG 1
#include <stdio.h>
void yyerror(const char *message);
int yylex();
int error_flag = 0;
int temp;

int binary_stack[100];
int top = 0;

double ans = 0.0;
%}

%union {
    double fval;
}

%token FFUNC GFUNC HFUNC LPAREN RPAREN COMMA OTHERS DGDX DGDY
%token<fval> NUM
%type<fval> func expression Unary_call Binary_call Ternary_call

%%
start   :   func { ans = $1;}
        |   err_token
        ;

func    :   Unary_call {
            $$ = $1;
        }
        |   Binary_call {
            $$ = $1;
        }
        |   Ternary_call {
            $$ = $1;
        }
        ;

Unary_call  :   Unary_op LPAREN expression RPAREN {
                $$ = 5 * $3 * $3 + 6 * $3 + 4;
                temp = $$ = 5 * $3 * $3 + 6 * $3 + 4;
                //printf("FUNC %d ", temp);
            }
            ;

Binary_call :   Binary_op LPAREN expression COMMA expression RPAREN {
                char peak = binary_stack[--top];
                if (peak == 'G') {
                    $$ = 6 * $3 * $3 + 3 * $3 + 8 * $5 * $5 - 15 * $5;
                    temp = 6 * $3 * $3 + 3 * $3 + 8 * $5 * $5 - 15 * $5;
                    //printf("GUNC %d ", temp);
                } else if (peak == 'X') {
                    $$ = 12 * $3 + 3;
                    temp = 12 * $3 + 3;
                    //printf("DGDX %d ", temp);
                } else if (peak == 'Y') {
                    $$ = 16 * $5 - 15;
                    temp = 16 * $5 - 15;
                    //printf("DGDY %d ", temp);
                }
            }
            ;

Ternary_call    :   Ternary_op LPAREN expression COMMA expression COMMA expression RPAREN {
                    $$ = $3 + $5 - $7;
                    temp = $3 + $5 - $7;
                    //printf("HUNC %d ", temp);
                    // 108 3 65 46
                }
                ;

Unary_op    :   FFUNC {
                ;
            }
            ;

Binary_op   : GFUNC {
                binary_stack[top++] = 'G';
            }
            | DGDX {
                binary_stack[top++] = 'X';
            }
            | DGDY {
                binary_stack[top++] = 'Y';
            }
            ;

Ternary_op  :   HFUNC {
                ;
            }
            ;

expression  :   func { $$ = $1; }
            |   NUM  { $$ = $1; }
            ;

err_token   :   OTHERS { yyerror(""); }
            ;
%%

void yyerror (const char *message) {
    error_flag = 1;
}

int main(int argc, char *argv[]) {
    //yydebug = 1;
    yyparse();
    if (error_flag == 0) {
        printf("%.3f\n", ans);
    } else {
        printf("Invalid");
    }


    return(0);
}