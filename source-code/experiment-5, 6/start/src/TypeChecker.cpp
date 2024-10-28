#include "TypeChecker.h"

string TypeChecker::visit_binary(BinaryExpression *node, Scope<string> *scope) {
  return "TO DO";
}

string TypeChecker::visit_unary(UnaryExpression *node, Scope<string> *scope) {
  return "TO DO";
}

string TypeChecker::visit_identifier(IdentifierExpression *node,
                                     Scope<string> *scope) {
  return "TO DO";
}

string TypeChecker::visit_constant(ConstantExpression *node,
                                   Scope<string> *scope) {
  return "TO DO";
}

string TypeChecker::visit_this(ThisExpression *node, Scope<string> *scope) {
  return "TO DO";
}

string TypeChecker::visit_new(NewExpression *node, Scope<string> *scope) {
  return "TO DO";
}

string TypeChecker::visit_new_array(NewIntArrayExpression *node,
                                    Scope<string> *scope) {
  return "TO DO";
}

string TypeChecker::visit_index_access(IndexExpression *node,
                                       Scope<string> *scope) {
  return "TO DO";
}

string TypeChecker::visit_call(MethodCallExpression *node,
                               Scope<string> *scope) {
  return "TO DO";
}

void TypeChecker::visit_block(BlockStatement *statement, Scope<string> *scope) {
  // TO DO
}

void TypeChecker::visit_if(IfStatement *statement, Scope<string> *scope) {
  // TO DO
}

void TypeChecker::visit_while(WhileStatement *statement, Scope<string> *scope) {
  // TO DO
}

void TypeChecker::visit_index_assign(IndexAssignStatement *statement,
                                     Scope<string> *scope) {
  // TO DO
}

void TypeChecker::visit_assign(AssignStatement *statement,
                               Scope<string> *scope) {
  // TO DO
}

void TypeChecker::visit_method_decl(MethodDeclStatement *statement,
                                    Scope<string> *scope) {
  // TO DO
}

void TypeChecker::visit_class_decl(ClassDeclStatement *statement,
                                   Scope<string> *scope) {
  // TO DO
}

void TypeChecker::visit_print_line(PrintLineStatement *statement,
                                   Scope<string> *scope) {
  // TO DO
}

void TypeChecker::node_to_statement(Expression *node, Scope<string> *scope) {
  visit(node, scope);
}

void TypeChecker::collect_super_classes(
    ClassDeclStatement *current, vector<ClassDeclStatement *> &super_classes,
    unordered_set<ClassDeclStatement *> &visited) {
  if (visited.count(current)) {
    throw Error(current->line(), "a class cannot inherit its dervied class '" +
                                     current->name() + "' or itself");
  } else if (current->super_class_name.has_value()) {
    auto next_class_name = current->super_class_name.value();
    if (program->classes.has_key(next_class_name)) {
      auto next_class = program->classes.find_by_key(next_class_name);
      super_classes.push_back(next_class);
      collect_super_classes(next_class, super_classes, visited);
    } else {
      throw Error(current->line(),
                  "cannot find super class '" + next_class_name + "'");
    }
  } else {
    // pass
  }
}
void TypeChecker::fix_class_inheritance() {
  unordered_map<ClassDeclStatement *, Table<string, FieldDecl *>> field_map;
  unordered_map<ClassDeclStatement *, Table<string, MethodDeclStatement *>>
      method_map;
  for (auto class_decl : program->classes.values) {
    vector<ClassDeclStatement *> super_classes;
    unordered_set<ClassDeclStatement *> visited;
    collect_super_classes(class_decl, super_classes, visited);
    std::reverse(super_classes.begin(), super_classes.end());
    for (auto super_class : super_classes) {
      for (auto field : super_class->fields.values) {
        field_map[class_decl].add(field->name(), field);
      }
      for (auto method : super_class->methods.values) {
        method_map[class_decl].add(method->name(), method);
      }
    }
    for (auto field : class_decl->fields.values) {
      field_map[class_decl].add(field->name(), field);
    }
    for (auto method : class_decl->methods.values) {
      method_map[class_decl].add(method->name(), method);
    }
  }

  for (auto class_decl : program->classes.values) {
    class_decl->fields = field_map[class_decl];
    class_decl->methods = method_map[class_decl];
  }
}

void TypeChecker::check_program() {
  fix_class_inheritance();
  Scope<string> scope;
  for (auto _class : program->classes.values) {
    visit_class_decl(_class, &scope);
  }
  visit_method_decl(program->entry_point, &scope);
}