%{
#include <iostream>
int word_count = 0;
%}

%%
[^" "\r\t\n]+  { word_count++; }
"\n" {
    std::cout << "Word count: " << word_count << std::endl;
    word_count = 0;
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