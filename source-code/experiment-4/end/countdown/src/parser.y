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
void view_ast(Expression* exp);
void view_statement(Statement* statement);

MethodDeclStatement* method;
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

%start Method

%%
Method
    : PUBLIC TYPE_INT IDENTIFIER '(' ')' '{' StatementList RETURN E ';''}'{
        method = new MethodDeclStatement(yylineno, $3->text, vector<ParameterDecl*>(), vector<VarDecl*>(),
            new BlockStatement(yylineno, singly_linked_list_to_vector($7)), $9, "int");
    }
    | PUBLIC TYPE_INT IDENTIFIER '(' ')' '{' RETURN E ';''}'{
        method = new MethodDeclStatement(yylineno, $3->text, vector<ParameterDecl*>(), vector<VarDecl*>(),
            new BlockStatement(yylineno, vector<Statement*>()), $8, "int");
    }
    ;


Statement
    : '{' '}' { $$ = new BlockStatement(yylineno, vector<Statement*>()); }
    | '{' StatementList '}' { $$ = new BlockStatement(yylineno, singly_linked_list_to_vector($2)); }
    | PRINT_LINE '(' E ')' ';' { $$ = new PrintLineStatement(yylineno, $3); }
    ;


StatementList
    : Statement { $$ = new SLinkedList<Statement*>($1, nullptr); }
    | StatementList Statement { $$ = new SLinkedList<Statement*>($2, $1); }
    ;

E
    : E OP_LOGICAL_AND E { $$ = new BinaryExpression(yylineno, NodeType::LOGICAL_AND, $1, $3); }
    | E '<' E { $$ = new BinaryExpression(yylineno, NodeType::LESS_THAN, $1, $3); }
    | E '+' E { $$ = new BinaryExpression(yylineno, NodeType::ADD, $1, $3); }
    | E '-' E { $$ = new BinaryExpression(yylineno, NodeType::SUBTRACT, $1, $3); }
    | E '*' E { $$ = new BinaryExpression(yylineno, NodeType::MULTIPLY, $1, $3); }
    | LITERAL_INTEGER { $$ = new ConstantExpression(yylineno, NodeType::INTEGER, $1->text); }
    | LITERAL_BOOLEAN { $$ = new ConstantExpression(yylineno, NodeType::BOOLEAN, $1->text); }
    | IDENTIFIER { $$ = new IdentifierExpression(yylineno, $1->text); }
    | '!' E { $$ = new UnaryExpression(yylineno, NodeType::NOT, $2); }
    | '(' E ')' { $$ = $2; }
    ;
%%

void yyerror(string s) {
    cerr << "line " << yylineno << ": " << s << endl;
}

void view_ast(Expression* exp) {
    JsonVisitor json_visitor;
    cout << std::setw(4) << json_visitor.visit(exp) << endl;
}

void view_statement(Statement* statement) {
    JsonVisitor json_visitor;
    cout << std::setw(4) << json_visitor.visit_statement(statement) << endl;
}

int main(int argc, char** argv) {
    yyparse();

    try {
        view_statement(method);
    } catch (Error& err) {
        cout << err.msg << endl;
    }
    return 0;
}
