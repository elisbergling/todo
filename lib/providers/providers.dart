import 'package:hooks_riverpod/all.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/services/hive_todo.dart';

final hiveTodosProvider = Provider<HiveTodo>((ref) => HiveTodo());

final todoFilterProvider = StateProvider((_) => TodoFilter.all);
