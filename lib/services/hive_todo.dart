import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/models/todo.dart';
import 'package:uuid/uuid.dart';

class HiveTodo {
  Future openBox({required String noteId}) async {
    try {
      await Hive.openBox<Todo>(noteId);
    } catch (e) {
      print(e);
    }
  }

  Future closeBox({required String noteId}) async {
    try {
      await Hive.box(noteId).close();
    } catch (e) {
      print(e);
    }
  }

  Box<Todo>? getTodos({required String noteId}) {
    try {
      return Hive.box<Todo>(noteId);
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<Todo>? sortedTodos({
    required List<Todo> todos,
    required StateController<TodoFilter> todoFilter,
    required String searchText,
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

  void updateTodos({
    required String noteId,
    required int oldIndex,
    required int newIndex,
    required List<Todo> todos,
  }) {
    try {
      if (oldIndex < newIndex) {
        todos[oldIndex].index = newIndex - 1;
        Hive.box<Todo>(noteId).put(todos[oldIndex].id, todos[oldIndex]);
        for (int i = oldIndex + 1; i < newIndex; i++) {
          todos[i].index = todos[i].index - 1;
          Hive.box<Todo>(noteId).put(todos[i].id, todos[i]);
        }
      } else {
        todos[oldIndex].index = newIndex;
        Hive.box<Todo>(noteId).put(todos[oldIndex].id, todos[oldIndex]);
        for (int i = newIndex; i < oldIndex; i++) {
          todos[i].index = todos[i].index + 1;
          Hive.box<Todo>(noteId).put(todos[i].id, todos[i]);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void makeTodo({
    required String noteId,
    required Todo todo,
    required bool isNew,
  }) {
    try {
      if (todo.title != '' || todo.description != '') {
        Uuid uuid = Uuid();
        if (isNew) {
          todo.id = uuid.v4();
          todo.index = Hive.box<Todo>(noteId).length;
        }
        Hive.box<Todo>(noteId).put(todo.id, todo);
      }
    } catch (e) {
      print(e);
    }
  }

  void deleteTodo({
    required String noteId,
    required String id,
  }) {
    try {
      Hive.box<Todo>(noteId).delete(id);
    } catch (e) {
      print(e);
    }
  }

  void toogleIsDoneTodo({
    required String noteId,
    required Todo todo,
  }) {
    try {
      todo.isDone = !todo.isDone;
      Hive.box<Todo>(noteId).put(todo.id, todo);
    } catch (e) {
      print(e);
    }
  }
}
