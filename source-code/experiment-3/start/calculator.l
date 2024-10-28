%{
#include <iostream>
#include "y.tab.h"
extern int yylval;
%}

%%
// TO DO

. { std::cerr << "ERROR!!! UNEXPECTED TOKEN: " << yytext << std::endl; }
%%

int yywrap() {
    return 1;
}