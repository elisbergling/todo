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
      String lowerText = searchText.toLowerCase();
      List<Todo> newTodos = todos
          .where((e) =>
              e.description.toLowerCase().contains(lowerText) ||
              e.title.toLowerCase().contains(lowerText))
          .toList();
      newTodos.sort((a, b) => a.index.compareTo(b.index));
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

  void updateTodos({int oldIndex, int newIndex, List<Todo> todos}) {
    try {
      if (oldIndex < newIndex) {
        todos[oldIndex].index = newIndex - 1;
        todoBox.put(todos[oldIndex].id, todos[oldIndex]);
        for (int i = oldIndex + 1; i < newIndex; i++) {
          todos[i].index = todos[i].index - 1;
          todoBox.put(todos[i].id, todos[i]);
        }
      } else {
        todos[oldIndex].index = newIndex;
        todoBox.put(todos[oldIndex].id, todos[oldIndex]);
        for (int i = newIndex; i < oldIndex; i++) {
          todos[i].index = todos[i].index + 1;
          todoBox.put(todos[i].id, todos[i]);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void makeTodo({Todo todo, bool isNew}) {
    try {
      if (todo.title != '' || todo.description != '') {
        Uuid uuid = Uuid();
        if (isNew) {
          todo.id = uuid.v4();
          todo.index = todoBox.length;
        }
        todoBox.put(todo.id, todo);
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
      todo.isDone = !todo.isDone;
      todoBox.put(todo.id, todo);
    } catch (e) {
      print(e);
    }
  }
}
