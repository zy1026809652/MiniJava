%{
#include <iostream>

void show_token(const std::string& token_type, const std::string& text);
%}

%%
"class" { show_token("CLASS", yytext); }
"public" { show_token("PUBLIC", yytext); }
"static" { show_token("STATIC", yytext); }
"if" { show_token("IF", yytext); }
"else" { show_token("ELSE", yytext); }
"while" { show_token("WHILE", yytext); }
"true" { show_token("TRUE", yytext); }
"false" { show_token("FALSE", yytext); }
"new" { show_token("NEW", yytext); }
"System.out.println" { show_token("SYSTEM.OUT.PRINTLN", yytext); }
";" { show_token("SEMICOLON", yytext); }
"(" { show_token("LEFT_PARENTHESIS", yytext); }
")" { show_token("RIGHT_PARENTHESIS", yytext); }
"[" { show_token("LEFT_BRACKET", yytext); }
"]" { show_token("RIGHT_BRACKET", yytext); }
"{" { show_token("LEFT_BRACE", yytext); }
"}" { show_token("RIGHT_BRACE", yytext); }
"!" { show_token("NOT", yytext); }
"=" { show_token("ASSIGN", yytext); }
"<" { show_token("LESS_THAN", yytext); }
"&&" { show_token("AND", yytext); }
"+" { show_token("ADD", yytext); }
"-" { show_token("SUBTRACT", yytext); }
"*" { show_token("MULTIPLY", yytext); }
"." { show_token("DOT", yytext); }
([a-zA-Z]|"_")([a-zA-Z0-9]|"_")* { show_token("IDENTIFIER", yytext); }
[0-9]+ { show_token("INTEGER", yytext); }
[" "\t\r\n]+ { /* skip whitespaces */ }
"//".*"\n"         { /* skip a piece of single-line comment */ }
"/*"(.|"\n")*"*/" { /* skip multi-line comments */ }
. { std::cerr << "ERROR!!! UNEXPECTED TOKEN: " << yytext << std::endl; }
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