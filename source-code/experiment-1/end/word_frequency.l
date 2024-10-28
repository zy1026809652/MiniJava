%{
#include <iostream>
#include <unordered_map>
std::unordered_map<std::string, int> word_map;
%}

%%
[a-zA-Z]+  { word_map[yytext]++; }
"\n" {
    for (const auto& pair : word_map) {
        const std::string& word = pair.first;
        int count = pair.second;
        std::cout << word << ": " << count << std::endl;
    }
    word_map.clear();
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