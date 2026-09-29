%{
#include <stdio.h>
int is_valid = 1;
int mul_com = 0;
int temp_num;
char str_num[110];
char temp[110];

int output_index = 0;

typedef struct {
    char type[110];
    char value[110];
} Output;

Output outputs[55];
Output current;

%}
%option noyywrap
KEYWORD     ([Ss][Ee][Ll][Ee][Cc][Tt])|([Ff][Rr][Oo][Mm])|([Ww][Hh][Ee][Rr][Ee])|([Aa][Nn][Dd])|([Oo][Rr])
IDENTIFIER  [a-zA-Z_][a-zA-Z0-9_]*
NUMBER      [+\-]?[0-9]+
STRING      \'([^\n]+(\'\'[^\n]+)*)\'
OPERATOR    [*=><]|(>=)|(<=)|(!=)
PUNCTUATION [,;]
SIN_COMMENT --[ ][^\n]*
MUL_COMMENT_H \/\*
MUL_COMMENT_T \*\/
NEXTLINE    \n
SPACE       [ \t]+
OTHER       .

%%
{KEYWORD}       {
    if (mul_com == 0) {
        strcpy(temp, yytext);
        for (int i = 0; i < sizeof(temp); i++) {
            if (temp[i] >= 97 && temp[i] <= 123) {
                temp[i] = temp[i] - 32;
            }
        }
        strcpy(current.type, "KEYWORD");
        strcpy(current.value, temp);
        outputs[output_index++] = current;
    }
}

{IDENTIFIER}    {
    if (mul_com == 0) {
        strcpy(current.type, "IDENTIFIER");
        strcpy(current.value, yytext);
        outputs[output_index++] = current;
    }
}

{NUMBER}        {
    if (mul_com == 0) {
        temp_num = atoi(yytext);
        int j = 0;
        int mod;
        int start_mem = 0;
        // printf("[%d]", temp_num);

        if (temp_num < 0) {
            temp_num = -temp_num;
            start_mem = 1;
            str_num[0] = '-';
        }
        if (temp_num != 0) {
            while (temp_num != 0) {
                mod = temp_num % 10;
                temp[j] = mod + 48;
                temp_num = temp_num / 10;
                j++;
            }
            temp[j] = '\0';
            // printf("[%s]", temp);

            int end_mem = j;
            for (int i = 0; i <= end_mem; i++) {
                str_num[i + start_mem] = temp[j-1];
                j--;
                // printf("%d", j);
            }
            str_num[end_mem + start_mem] = '\0';
            // printf("[%s %d]", str_num, start_mem);
        } else {
            str_num[0] = '0';
            str_num[1] = '\0';
        }
            
        strcpy(current.type, "NUMBER");
        strcpy(current.value, str_num);
        outputs[output_index++] = current;
    }
}

{STRING}        {
    if (mul_com == 0) {
        int i = 1;
        int k = 0;
        // printf("%d", strlen(yytext) -1);
        while (i < strlen(yytext) - 1) {
            if (yytext[i] != '\'') {
                temp[k] = yytext[i];
                k++;
            } else if (yytext[i] == '\'' && i < strlen(yytext) - 2) {
                if (yytext[i+1] == '\'') {
                    temp[k] = '\'';
                    k++;
                    i++;
                }
            }
            // printf("[%c | %c]", yytext[i], temp[i-1]);
            i++;
        }
        temp[k] = '\0';
        strcpy(current.type, "STRING");
        strcpy(current.value, temp);
        outputs[output_index++] = current;
    }
}

{OPERATOR}      {
    if (mul_com == 0) {
        strcpy(current.type, "OPERATOR");
        strcpy(current.value, yytext);
        outputs[output_index++] = current;
    }
}

{PUNCTUATION}   {
    if (mul_com == 0) {
        strcpy(current.type, "PUNCTUATION");
        strcpy(current.value, yytext);
        outputs[output_index++] = current;
    }
}

{SIN_COMMENT}   {
    ;
}

{MUL_COMMENT_H} {
    mul_com++;
}

{MUL_COMMENT_T} {
    mul_com--;
}

{NEXTLINE}      {
    ;
}

{SPACE}         {
    ;
}

{OTHER}         {
    if(mul_com == 0) is_valid = 0;
}

%%
int main(){
    yylex();
    if (is_valid == 1) {
        for (int i = 0; i < output_index; i++) {
            printf("%s\n", outputs[i].type);
            printf("%s\n", outputs[i].value);
        }
    } else {
        printf("INVALID\n");
    }

    return 0;
}