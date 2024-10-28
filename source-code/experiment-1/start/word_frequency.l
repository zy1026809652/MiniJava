%{
#include <iostream>
#include <unordered_map>
std::unordered_map<std::string, int> word_map;
%}

%%
[a-zA-Z]+  { /* TO DO */ }
"\n" {
    /* TO DO */
}
.  { /* skip non-letter characters */ }
%%

int yywrap(void) {
    return 0;
}

int main() {
    std::cout << "Enter a sentence: " << std::endl;
    yylex();

    return 0;
}