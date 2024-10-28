%{
#include <iostream>
#include "y.tab.h"
extern int yylval;
%}

%%
[0-9]+ {
    yylval = std::stoi(yytext);
    return NUMBER;
}

[" "\t] { /* skip whitespaces */ }
[\n] { return 0; }

"+" { return ADD; }
"-" { return SUBTRACT; }
"*" { return MULTIPLY; }
"/" { return DIVIDE; }
"(" { return LEFT_PARENTHESIS; }
")" { return RIGHT_PARENTHESIS; }

. { std::cerr << "ERROR!!! UNEXPECTED TOKEN: " << yytext << std::endl; }
%%

int yywrap() {
    return 1;
}