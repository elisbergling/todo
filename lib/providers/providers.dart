import 'package:hooks_riverpod/all.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/services/hive_todo.dart';

final hiveTodosProvider = Provider<HiveTodo>((ref) => HiveTodo());

final todoFilterProvider = StateProvider<TodoFilter>((_) => TodoFilter.all);

final searchContollerProvider = StateProvider<String>((_) => '');

final sortedTodosProvider = Provider.family<List<Todo>, List<Todo>>(
  (ref, todos) => ref.watch(hiveTodosProvider).sortedTodos(
        searchText: ref.watch(searchContollerProvider).state,
        todos: todos,
        todoFilter: ref.watch(todoFilterProvider),
      ),
);
