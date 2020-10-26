import 'package:hive/hive.dart';
import 'package:todo/constants/strings.dart';
import 'package:todo/models/todo.dart';

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

  void createTodo({Todo todo}) {
    try {
      if (todo.title != '' || todo.description != '') {
        todoBox.add(todo);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteTodo({int i}) {
    try {
      todoBox.deleteAt(i);
    } catch (e) {
      print(e);
    }
  }

  void updateTodo({int i, Todo todo}) {
    try {
      if (todo.title != '' || todo.description != '') {
        todoBox.putAt(i, todo);
      }
    } catch (e) {
      print(e);
    }
  }

  void toogleIsDoneTodo({int i, Todo todo}) {
    try {
      Todo newTodo = Todo(
        title: todo.title,
        description: todo.description,
        isDone: !todo.isDone,
      );
      todoBox.putAt(i, newTodo);
    } catch (e) {
      print(e);
    }
  }
}
