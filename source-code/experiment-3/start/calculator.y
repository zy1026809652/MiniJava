%{
#include <iostream>
bool has_error = false;
void yyerror(const char *s);
int yylex();
%}

%token NUMBER ADD SUBTRACT MULTIPLY DIVIDE LEFT_PARENTHESIS RIGHT_PARENTHESIS

%left ADD SUBTRACT

%left MULTIPLY DIVIDE

%left LEFT_PARENTHESIS RIGHT_PARENTHESIS

%%
// TO DO
%%

int main() {
    std::cout << ">>> ";
    yyparse();
    if (has_error) {
        return 1;
    } else {
        return 0;
    }
}

void yyerror(const char*) {
    std::cout << "invalid expression" << std::endl;
    has_error = true;
}