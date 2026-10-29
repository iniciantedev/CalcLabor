%{
#include <stdlib.h>
#include "y.tab.h"

extern void yyerror(char *c);
int yywrap();
extern int yylex();
%}

%%

[0-9]+ { 
yylval.I = atoi(yytext);
return INT; }

[a-zA-Z][a-zA-Z0-9]* { 
strcpy(yylval.S, yytext);
return VAR; }

[=] { return EQ; }

[+] { return SUM; }

[-] { return MIN; }

[*] { return MUL; }

[/] { return DIV; }

\n+ { return EOL; }

[[:space:]]+ ;

. { yyerror("unexpected token\n"); }

%%

int yywrap(){
	return 1;
}
