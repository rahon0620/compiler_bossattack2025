%{
#include <stdio.h>
int line_number = 1;
int state_CAPSLOCK = 0;
int typo_count = 0;
int has_typo = 0;

char temp[10];
char KEY[4];
char WORD[5];
%}
%option noyywrap
KEYWORD   [a-zA-Z]{3,4}
STR         \"[^\n\"]+\"
CAPSLOCK    CAPSLOCK
SPACE       [ \t]+
NEXTLINE    \n
OTHER       .

%%
{KEYWORD} {
            typo_count = 0;
            strcpy(temp, yytext);
            if (state_CAPSLOCK == 1) {
                for (int i = 0; i < sizeof(temp); i++) {
                    if (temp[i] >= 97 && temp[i] <= 123) {
                        temp[i] = temp[i] - 32;
                    }
                }
            }

            if (strlen(temp) == 3) {
                for (int i = 0; i <= 2 ; i++) {
                    if (temp[i] != KEY[i]) typo_count++;
                }
            } else if (strlen(temp) == 4) {
                for (int i = 0; i <= 3 ; i++) {
                    if (temp[i] != WORD[i]) typo_count++;
                }
            }

            if (typo_count == 1) {
                has_typo = 1;
                if (strlen(temp) == 3) printf("In line %d, '%s' was not declared in this scope; did you mean 'KEY'?\n", line_number, temp);
                if (strlen(temp) == 4) printf("In line %d, '%s' was not declared in this scope; did you mean 'WORD'?\n", line_number, temp);
            }
        }
{STR}   {;}
{CAPSLOCK} {if(state_CAPSLOCK == 0) state_CAPSLOCK = 1;}
{SPACE} {;}
{NEXTLINE} {state_CAPSLOCK = 0; line_number++;}
{OTHER} {;}
%%
int main(){
    KEY[0] = 'K'; KEY[1] = 'E'; KEY[2] = 'Y'; KEY[3] = '\0';
    WORD[0] = 'W'; WORD[1] = 'O'; WORD[2] = 'R'; WORD[3] = 'D'; WORD[4] = '\0';
    yylex();
    if (has_typo == 0) printf("No typo.");
    return 0;
}