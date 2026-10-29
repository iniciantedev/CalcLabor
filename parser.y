%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define TABLE_SIZE 100

void yyerror(char *c);
int yylex();
typedef struct {
	char *name;
	int value;
} V;
int variables = 0;
V table[TABLE_SIZE];

int setup_table() {
for (int i = 0; i < TABLE_SIZE; i++) {
	table[i].name = calloc(30, sizeof(char));
}
return 0;
}

int free_table() {
for (int i = 0; i < TABLE_SIZE; i++) {
	free(table[i].name);
}
return 0;
}

int search(char *name) {
int i;
for (i = 0; i < TABLE_SIZE; i++) {
	if(strcmp(table[i].name, name) == 0) {
	return i;
	}
}

return -1;

}

int atribute(char *name, int value){
int r = search(name);
if(r == -1){
strcpy(table[variables].name, name);
table[variables].value = value;
variables++;
} else {
table[r].value = value;
}
return 0;
}

void yyerror(char *c) {
printf("Error: %s", c);
free_table();
exit(1);
}
%}

%union value {
int I;
char S[100];
}

%token INT EQ SUM EOL VAR MIN MUL DIV
%left SUM MIN
%left DIV MUL
%%

S:
  S L {}
  |
  ;

L:
  E EOL { printf("Resultado: %d\n", $<I>1); }
  | VAR EQ E EOL { atribute($<S>1, $<I>3); }
  | EOL
  ;

E:
  VAR {
	char data[100];
	strcpy(data, $<S>1);
	int r = search(data);
	if(r == -1) {
		char error[30];
		snprintf(error, sizeof(error)-1, "Variable %s not found\n", data);
		yyerror(error);
	}
	$<I>$ = table[r].value;
	}
  | INT { $<I>$=$<I>1; }
  | E DIV E { $<I>$=$<I>1/$<I>3; }
  | E MUL E { $<I>$=$<I>1*$<I>3; }
  | E MIN E { $<I>$=$<I>1-$<I>3; }
  | E SUM E { $<I>$=$<I>1+$<I>3; }
  ;

%%

int main() {
	setup_table();
	yyparse();
	free_table();
	return 0;
}

