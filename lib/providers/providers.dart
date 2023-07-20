import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/models/note.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/services/hive_note.dart';
import 'package:todo/services/hive_settings.dart';
import 'package:todo/services/hive_todo.dart';

//General

final searchContollerProvider = StateProvider<String>((_) => '');

final colorProvider = StateProvider<Color>((ref) =>
    Color(ref.watch(hiveSettingsProvider).getColor() ?? MyColors.red.value));

//Todo

final hiveTodosProvider = Provider<HiveTodo>((ref) => HiveTodo());

final todoFilterProvider = StateProvider<TodoFilter>((_) => TodoFilter.all);

final sortedTodosProvider = Provider.family<List<Todo>?, List<Todo>>(
  (ref, todos) => ref.watch(hiveTodosProvider).sortedTodos(
        searchText: ref.watch(searchContollerProvider).state,
        todos: todos,
        todoFilter: ref.watch(todoFilterProvider),
      ),
);

//Note

final hiveNotesProvider = Provider<HiveNote>((ref) => HiveNote());

final sortedNotesProvider = Provider.family<List<Note>?, List<Note>>(
  (ref, notes) => ref.watch(hiveNotesProvider).sortedNotes(
        searchText: ref.watch(searchContollerProvider).state,
        notes: notes,
      ),
);

//Settings

final hiveSettingsProvider = Provider<HiveSettings>((ref) => HiveSettings());
