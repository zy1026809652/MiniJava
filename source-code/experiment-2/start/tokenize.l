%{
#include <iostream>

void show_token(const std::string& token_type, const std::string& text);
%}

%%
/* TO DO */
%%

int yywrap(void) {
    return 1;
}

void show_token(const std::string& token_type, const std::string& text) {
　// print the token
  std::cout << "(" << token_type << ", " << text << ")" << std::endl;
}

int main() {
    yylex();

    return 0;
}