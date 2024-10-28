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
Node: E {
    std::cout << "result: " << $$ << std::endl;
    return 0;
};
E: E ADD E { $$ = $1 + $3; }
|  E SUBTRACT E { $$ = $1 - $3; }
|  E MULTIPLY E { $$ = $1 * $3; }
|  E DIVIDE E { $$ = $1 / $3; }
|  LEFT_PARENTHESIS E RIGHT_PARENTHESIS { $$ = $2; }
| NUMBER { $$ = $1; }
;
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