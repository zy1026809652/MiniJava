%{
#include "Token.h"
#include "Node.h"
#include "JsonVisitor.h"
#include <iostream>
#include <fstream>
#include <iomanip>

using std::string;
using std::cout;
using std::cerr;
using std::endl;

extern int yylineno;

int yylex();
void yyerror(string s);
void program_to_json(Program* program);
void view_ast(Expression* exp);

Program* program;
%}

%union {
    Token* token;
    Expression* ast;
    Statement* stmt;
    SLinkedList<Statement*>* stmt_list;
    SLinkedList<Expression*>* node_list;
    SLinkedList<ParameterDecl*>* parameter_list;
    MethodDeclStatement* method_decl;
    SLinkedList<MethodDeclStatement*>* method_list;
    VarDecl* var_decl;
    SLinkedList<VarDecl*>* var_list;
    ClassDeclStatement* class_decl;
    SLinkedList<ClassDeclStatement*>* class_list;
    string* str;
}

%token PUBLIC
%token STATIC
%token VOID
%token MAIN
%token CLASS
%token EXTENDS
%token RETURN
%token TYPE_INT
%token TYPE_BOOLEAN
%token IF
%token ELSE
%token WHILE
%token PRINT_LINE
%token THIS
%token <token> LITERAL_BOOLEAN
%token NEW
%token LENGTH
%token STRING
%token OP_LOGICAL_AND

%token <token> IDENTIFIER
%token <token> LITERAL_INTEGER

%left OP_LOGICAL_AND
%nonassoc '<'
%left '+' '-' '*'
%right '='
%right '!'
%left '[' ']'
%left '(' ')'
%left '{' '}'
%left ','
%left '.'

%type <ast> E
%type <stmt> Statement
%type <stmt_list> StatementList
%type <node_list> ArgumentList
%type <method_decl> MainClass
%type <str> Type
%type <parameter_list> ParameterList
%type <method_list> MethodList
%type <method_decl> Method
%type <var_decl> Var
%type <var_list> VarList
%type <class_decl> ClassDecl
%type <class_list> ClassList

%start Program

%%
// TO DO
%%

void yyerror(string s) {
    cerr << "line " << yylineno << ": " << s << endl;
}

void program_to_json(Program* program) {
    JsonVisitor json_visitor;
    json json_obj = json_visitor.visit_program(program);
    cout << std::setw(4) << json_obj << endl;
}

void view_ast(Expression* exp) {
    JsonVisitor json_visitor;
    cout << std::setw(4) << json_visitor.visit(exp) << endl;
}

int main(int argc, char** argv) {
    yyparse();

    try {
        program_to_json(program);
    } catch (Error& err) {
        cout << err.msg << endl;
    }
    return 0;
}
