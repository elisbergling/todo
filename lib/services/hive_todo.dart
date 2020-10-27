import 'package:hive/hive.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/constants/strings.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/models/todo.dart';
import 'package:uuid/uuid.dart';

class HiveTodo {
  Box todoBox = Hive.box<Todo>(TODOS);

  Box<Todo> getTodos() {
    try {
      return todoBox;
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<Todo> sortedTodos({
    List<Todo> todos,
    StateController<TodoFilter> todoFilter,
    String searchText,
  }) {
    try {
      List<Todo> newTodos = todos
          .where((e) =>
              e.description.contains(searchText) ||
              e.title.contains(searchText))
          .toList();
      switch (todoFilter.state) {
        case TodoFilter.done:
          return newTodos.where((todo) => todo.isDone).toList();
        case TodoFilter.notDone:
          return newTodos.where((todo) => !todo.isDone).toList();
        case TodoFilter.all:
        default:
          return newTodos;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void makeTodo({Todo todo, bool isNew}) {
    try {
      if (todo.title != '' || todo.description != '') {
        Uuid uuid = Uuid();
        Todo newTodo;
        if (isNew) {
          newTodo = Todo(
            title: todo.title,
            isDone: todo.isDone,
            description: todo.description,
            id: uuid.v4(),
          );
        } else {
          newTodo = todo;
        }
        todoBox.put(newTodo.id, newTodo);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteTodo({String id}) {
    try {
      todoBox.delete(id);
    } catch (e) {
      print(e);
    }
  }

  void toogleIsDoneTodo({Todo todo}) {
    try {
      Todo newTodo = Todo(
          title: todo.title,
          description: todo.description,
          isDone: !todo.isDone,
          id: todo.id);
      todoBox.put(todo.id, newTodo);
    } catch (e) {
      print(e);
    }
  }
}
