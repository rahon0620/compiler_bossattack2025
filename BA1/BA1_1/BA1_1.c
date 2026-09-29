#include <stdio.h>
#include <string.h>
#include <ctype.h>

typedef enum {
    IDENTIFIER,
    INTEGER,
    STRING,
    DATETIME,
    COLON,
    SEMI_COLON,
    END,
    ERROR
} TokenType;

typedef struct {
    TokenType type;
    char text[500];
    int index;
} Token;

int current_char = ' ';
int token_count = 0;
int has_error = 0;
int has_NA = 0;
Token tokens[1000];
Token current;

void scan_token() {
    while (isspace(current_char)) { // clear space and \n
        current_char = getchar();
    }

    if (current_char == EOF) {
        current.type = END;
        return;
    }

    // identify symbols
    if (current_char == ':') { current.type = COLON; current_char = getchar(); return; }
    if (current_char == ';') { current.type = SEMI_COLON; current_char = getchar(); return; }


    // identify STRING
    if (current_char == '\"') {
            current.index = 0;
        current.text[0] = '\"';
        current_char = getchar();

        if (current_char == '_' || isdigit(current_char) || isalpha(current_char)) {
            current.text[1] = current_char;
            current_char = getchar();
            current.index = 2;
            while (current_char == '_' || isdigit(current_char) || isalpha(current_char)) {
                current.text[current.index] = current_char;
                current.index++;
                current_char = getchar();
            }
        } else {
            current.type = ERROR;
            while (current_char != '\"') current_char = getchar();
            if (current_char == '\"') current_char = getchar();
            return;
        }

        if (current_char == '\"') {
            current.text[current.index] = '\"';
            current.index++;
            current.text[current.index] = '\0';
            current.type = STRING;
            current_char = getchar();
            return;
        }

        current.type = ERROR;
        current_char = getchar();
        return;
    }

    // identify IDENTIFIER
    if (isalpha(current_char) || current_char == '_') {
        current.index = 0;
        while (isalpha(current_char) || current_char == '_') {
            current.text[current.index] = current_char;
            current.index++;
            current_char = getchar();
        }
        current.text[current.index] = '\0';
        current.type = IDENTIFIER;
        return;
    }

    // identify INTEGER or DATETIME
    if (isdigit(current_char)) {
        has_NA = 0;
        current.index = 0;
        while (isdigit(current_char) || current_char == '-' || current_char == 'T' || (current_char == ':' && current.index <19)) {
            if (!isdigit(current_char)) {
                has_NA = 1;
            }
            current.text[current.index] = current_char;
            current.index++;
            current_char = getchar();
        }
        current.text[current.index] = '\0';

        //[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}
        if (has_NA == 1 && current.index == 19 && current.text[4] == '-' && current.text[7] == '-' && current.text[10] == 'T' &&
            current.text[13] == ':' && current.text[16] == ':') {
            current.type = DATETIME;
        } else if (has_NA == 0) {
            current.type = INTEGER;
        } else {
            current.type = ERROR;
        }
        return;
    }

    current.type = ERROR;
    current_char = getchar();
    return;
}

void match(TokenType t) {
    if (current.type == t) {
        tokens[token_count++] = current;
        scan_token();
        return;
    } else {
        has_error = 1;
        return;
    }
}

void program() {
    entry();
    match(SEMI_COLON);
    if (current.type != END) {
        has_error = 1;
    }
    return;
}

void entry() {
    if (current.type == DATETIME) {
        record_log();
    } else if (current.type == IDENTIFIER) {
        record_val();
    }
    return;
}

void record_log() {
    match(DATETIME);
    match(COLON);
    match(STRING);
    return;
}

void record_val() {
    match(IDENTIFIER);
    match(COLON);
    value();
    return;
}

void value() {
    if (current.type == INTEGER) {
        match(INTEGER);
    } else if (current.type == STRING) {
        match(STRING);
    }
    return;
}

int main() {
    while (1) {
        scan_token();
        if (current.type == END) break;

        if (current.type == ERROR) {
            has_error = 1;
            break;
        }
        program();
    }

    if (has_error) {
        printf("Invalid input\n");
    } else {
        for (int i = 0; i < token_count; i++) {
            if (tokens[i].type == IDENTIFIER) printf("%s IDENTIFIER\n", tokens[i].text);
            if (tokens[i].type == INTEGER) printf("%s INTEGER\n", tokens[i].text);
            if (tokens[i].type == STRING) printf("%s STRING\n", tokens[i].text);
            if (tokens[i].type == DATETIME) printf("%s DATETIME\n", tokens[i].text);
            if (tokens[i].type == COLON) printf(": COLON\n");
            if (tokens[i].type == SEMI_COLON) printf("; SEMI_COLON\n");
        }
    }

    return 0;
}
