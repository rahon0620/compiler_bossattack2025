#include <stdio.h>
#include <string.h>
#include <ctype.h>

typedef enum {
    A,
    B,
    C,
    END,
    ERROR
} TokenType;

typedef struct {
    TokenType type;
    char char_value;
} Token;

int current_char = ' ';
int current_state = 0;
int token_count = 0;
int has_error = 0;
Token tokens[1000];
Token current;

// a+c*ba* ||

void scan_token() {

    while (isspace(current_char)) { // clear space and \n
        current_char = getchar();
    }

    if (current_char == EOF || current_char == '$') {
        current.type = END;
        return;
    }

    if (current_state == 1) {
        if (current_char == 'a') {
            current.type = A;
            current.char_value = 'a';
            current_state = 2;
            current_char = getchar();
        } else if (current_char == 'b') {
            current.type = B;
            current.char_value = 'b';
            current_state = 3;
            current_char = getchar();
        } else if (current_char == 'c') {
            current.type = C;
            current.char_value = 'c';
            current_state = 4;
            current_char = getchar();
        }
        return;
    } else if (current_state == 2) {
        if (current_char == 'a') {
            current.type = A;
            current.char_value = 'a';
            current_state = 2;
            current_char = getchar();
        } else if (current_char == 'b') {
            current.type = B;
            current.char_value = 'b';
            current_state = 4;
            current_char = getchar();
        } else if (current_char == 'c') {
            current.type = C;
            current.char_value = 'c';
            current_state = 2;
            current_char = getchar();
        }
        return;
    } else if (current_state == 3) {
        if (current_char == 'a') {
            current.type = A;
            current.char_value = 'a';
            current_state = 3;
            current_char = getchar();
        } else if (current_char == 'b') {
            current.type = B;
            current.char_value = 'b';
            current_state = 4;
            current_char = getchar();
        } else if (current_char == 'c') {
            current.type = C;
            current.char_value = 'c';
            current_state = 4;
            current_char = getchar();
        }
        return;
    } else if (current_state == 4) {
        if (current_char == 'a') {
            current.type = A;
            current.char_value = 'a';
            current_state = 4;
            current_char = getchar();
        } else if (current_char == 'b') {
            current.type = B;
            current.char_value = 'b';
            current_state = 2;
            current_char = getchar();
        } else if (current_char == 'c') {
            current.type = C;
            current.char_value = 'c';
            current_state = 1;
            current_char = getchar();
        }
        return;
    }

    current.type = ERROR;
    return;
}

int main() {
    current_state = 1;
    while(1) {
        scan_token();

        if (current.type == END) break;

        if (current.type == ERROR) {
            has_error = 1;
            break;
        }
        tokens[token_count++] = current;

    }



    if (has_error || ( current_state != 3 && current_state != 4)) {
        printf("NO");
    } else {
        printf("YES s%d", current_state);
    }

    return 0;
}

