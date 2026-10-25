T_FLEX=lex.yy.c
T_YACC=y.tab.c
S_FLEX=lexer.l
S_YACC=parser.y
T=lexer

all: $(T)

$(T): $(T_FLEX) $(T_YACC)
	gcc -o $(T) $(T_YACC) $(T_FLEX) -lfl

$(T_FLEX): $(S_FLEX)
	flex $(S_FLEX)


$(T_YACC): $(S_YACC)
	bison -dy $(S_YACC)

test: $(T)
	./lexer < test.code
