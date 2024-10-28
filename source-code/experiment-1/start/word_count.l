%{
#include <iostream>
int word_count = 0;
%}

%%
[^" "\r\t\n]+  { /* TO DO */ }
"\n" {
    /* TO DO */
}
[" "\r\t]+  { /* skip whitespaces */ }
%%

int yywrap(void) {
    return 0;
}

int main() {
    std::cout << "Enter a sentence: " << std::endl;
    yylex();

    return 0;
}