%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

void ThreeAddressCode();
void triple();
void quadraple();
char AddToTable(char, char, char);
int yylex(void);
int yyerror(char *s);

int ind = 0;
char temp = '1';

struct incod {
    char opd1;
    char opd2;
    char opr;
} code[20];
%}

%union {
    char sym;
}

%token <sym> LETTER NUMBER
%type <sym> expr
%left '+' '-'
%left '*' '/'

%%

statement:
    LETTER '=' expr ';'   { AddToTable($1, $3, '='); }
  | expr ';'              { /* Optional: support standalone expressions */ }
;

expr:
    expr '+' expr     { $$ = AddToTable($1, $3, '+'); }
  | expr '-' expr     { $$ = AddToTable($1, $3, '-'); }
  | expr '*' expr     { $$ = AddToTable($1, $3, '*'); }
  | expr '/' expr     { $$ = AddToTable($1, $3, '/'); }
  | '(' expr ')'      { $$ = $2; }
  | NUMBER            { $$ = $1; }
  | LETTER            { $$ = $1; }
  | '-' expr          { $$ = AddToTable($2, '\t', '-'); }
;

%%

char AddToTable(char opd1, char opd2, char opr) {
    code[ind].opd1 = opd1;
    code[ind].opd2 = opd2;
    code[ind].opr = opr;
    ind++;
    return temp++;
}

void ThreeAddressCode() {
    printf("\n\nTHREE ADDRESS CODE:\n");
    char t = '1';
    for (int i = 0; i < ind; i++) {
        if (code[i].opr != '=')
            printf("t%c := ", t++);
        if (isalpha(code[i].opd1))
            printf("%c ", code[i].opd1);
        else
            printf("t%c ", code[i].opd1);
        printf("%c ", code[i].opr);
        if (isalpha(code[i].opd2))
            printf("%c\n", code[i].opd2);
        else
            printf("t%c\n", code[i].opd2);
    }
}

void quadraple() {
    printf("\n\nQUADRUPLE CODE:\n");
    char t = '1';
    for (int i = 0; i < ind; i++) {
        printf("%c\t", code[i].opr);
        if (isalpha(code[i].opd1)) printf("%c\t", code[i].opd1);
        else printf("t%c\t", code[i].opd1);
        if (isalpha(code[i].opd2)) printf("%c\t", code[i].opd2);
        else if (code[i].opd2 == '\t') printf("-\t");
        else printf("t%c\t", code[i].opd2);
        if (code[i].opr != '=')
            printf("t%c\n", t++);
        else
            printf("%c\n", code[i].opd1);
    }
}

void triple() {
    printf("\n\nTRIPLE CODE:\n");
    for (int i = 0; i < ind; i++) {
        printf("(%d)\t%c\t", i, code[i].opr);
        if (isalpha(code[i].opd1)) printf("%c\t", code[i].opd1);
        else printf("(%c)\t", code[i].opd1);
        if (isalpha(code[i].opd2)) printf("%c\n", code[i].opd2);
        else if (code[i].opd2 == '\t') printf("-\n");
        else printf("(%c)\n", code[i].opd2);
    }
}

int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 0;
}

int main() {
    printf("Enter the expression: ");
    yyparse();
    ThreeAddressCode();
    quadraple();
    triple();
    return 0;
}

