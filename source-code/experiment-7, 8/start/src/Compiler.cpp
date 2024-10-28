#include "Compiler.h"
#include <algorithm>

void Compiler::add_op(ByteCode &bytes, Op op) {
  bytes.push_back(static_cast<Byte>(op));
}
void Compiler::add_u16(ByteCode &bytes, u16 value) {
  bytes.push_back(value / 256);
  bytes.push_back(value % 256);
}
void Compiler::rewrite_u16(ByteCode &bytes, size_t index, u16 value) {
  bytes.at(index) = value / 256;
  bytes.at(index + 1) = value % 256;
}
void Compiler::add_i32(ByteCode &bytes, i32 value) {
  size_t start = bytes.size();
  for (int i = 0; i < 4; i++) {
    bytes.push_back(value % 256);
    value = value / 256;
  }
  std::reverse(bytes.begin() + start, bytes.end());
}

void Compiler::visit_binary(BinaryExpression *node, ByteCode &bytes,
                            Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_unary(UnaryExpression *node, ByteCode &bytes,
                           Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_identifier(IdentifierExpression *node, ByteCode &bytes,
                                Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_constant(ConstantExpression *node, ByteCode &bytes,
                              Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_this(ThisExpression *node, ByteCode &bytes,
                          Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_new(NewExpression *node, ByteCode &bytes,
                         Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_new_array(NewIntArrayExpression *node, ByteCode &bytes,
                               Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_index_access(IndexExpression *node, ByteCode &bytes,
                                  Scope<u16> *scope) {
  // TO DO
}
void Compiler::visit_call(MethodCallExpression *node, ByteCode &bytes,
                          Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_block(BlockStatement *statement, ByteCode &bytes,
                           Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_if(IfStatement *statement, ByteCode &bytes,
                        Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_while(WhileStatement *statement, ByteCode &bytes,
                           Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_index_assign(IndexAssignStatement *statement,
                                  ByteCode &bytes, Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_assign(AssignStatement *statement, ByteCode &bytes,
                            Scope<u16> *scope) {
  // TO DO
}

void Compiler::visit_method_decl(MethodDeclStatement *statement,
                                 ByteCode &bytes, Scope<u16> *scope) {
  add_u16(bytes, statement->parameters.size());
  add_u16(bytes, statement->local_vars.size());
  Scope<u16> new_scope(scope);
  if (statement->name() == "main") {
    size_t index = 0;
    for (auto local_var : statement->local_vars) {
      new_scope.put(local_var->name(), index);
      index++;
    }
  } else {
    new_scope.put("this", 0);
    size_t index = 1;
    for (auto parameter : statement->parameters) {
      new_scope.put(parameter->name(), index);
      index++;
    }
    for (auto local_var : statement->local_vars) {
      new_scope.put(local_var->name(), index);
      index++;
    }
  }
  ByteCode function_bytes;
  visit_statement(statement->body, function_bytes, &new_scope);
  // process return expression
  if (statement->return_type == "int" || statement->return_type == "boolean") {
    visit(statement->return_exp, function_bytes, &new_scope);
    add_op(function_bytes, Op::RETURN_INT);
  } else if (statement->return_type == "int[]") {
    visit(statement->return_exp, function_bytes, &new_scope);
    add_op(function_bytes, Op::RETURN_INT_ARRAY);
  } else if (statement->return_type == "void") {
    add_op(function_bytes, Op::EXIT);
  } else {
    visit(statement->return_exp, function_bytes, &new_scope);
    add_op(function_bytes, Op::RETURN_OBJECT);
  }
  // merge
  add_u16(bytes, function_bytes.size());
  for (auto b : function_bytes) {
    bytes.push_back(b);
  }
}

void Compiler::visit_class_decl(ClassDeclStatement *statement, ByteCode &bytes,
                                Scope<u16> *scope) {
  this_class = statement;
  add_u16(bytes, statement->fields.values.size());
  add_u16(bytes, statement->methods.values.size());
  for (auto method : statement->methods.values) {
    visit_method_decl(method, bytes, scope);
  }
}

void Compiler::visit_print_line(PrintLineStatement *statement, ByteCode &bytes,
                                Scope<u16> *scope) {
  // TO DO
}

void Compiler::node_to_statement(Expression *node, ByteCode &bytes,
                                 Scope<u16> *scope) {
  visit(node, bytes, scope);
}

ByteCode Compiler::compile() {
  ByteCode bytes;
  Scope<u16> scope;
  visit_method_decl(program->entry_point, bytes, &scope);
  add_u16(bytes, program->classes.values.size());
  for (auto _class : program->classes.values) {
    visit_class_decl(_class, bytes, &scope);
  }
  return bytes;
}

void Compiler::push_this(ByteCode &bytes) {
  add_op(bytes, Op::PUSH_LOCAL_OBJECT);
  add_u16(bytes, 0); // first parameter
}