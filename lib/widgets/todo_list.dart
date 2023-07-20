import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/widgets/todo_item.dart';
import 'package:todo/widgets/todo_list_header.dart';

class TodoList extends HookWidget {
  const TodoList({
    super.key,
    required this.color,
    required this.titleTextEditingContorller,
    required this.descriptionTextEditingContorller,
    required this.searchContoller,
    required this.id,
  });

  final StateController<Color> color;
  final TextEditingController titleTextEditingContorller;
  final TextEditingController descriptionTextEditingContorller;
  final StateController<String> searchContoller;
  final String id;

  @override
  Widget build(BuildContext context) {
    final todos = useProvider(hiveTodosProvider);
    final todosListenable = useValueListenable(
            todos.getTodos(noteId: id)?.listenable() as ValueListenable)
        .values
        .toList();
    final sortedTodos =
        useProvider(sortedTodosProvider(todosListenable))?.toList() ?? [];
    final scrollController = useScrollController();
    return ReorderableListView(
      header: TodoListHeader(
        color: color,
        titleTextEditingContorller: titleTextEditingContorller,
        descriptionTextEditingContorller: descriptionTextEditingContorller,
        searchContoller: searchContoller,
      ),
      onReorder: (oldIndex, newIndex) =>
          context.read(hiveTodosProvider).updateTodos(
                noteId: id,
                oldIndex: oldIndex,
                newIndex: newIndex,
                todos: sortedTodos,
              ),
      scrollController: scrollController,
      children: sortedTodos
          .map((e) => TodoItem(
                todo: e,
                noteId: id,
                key: ValueKey(e.id),
              ))
          .toList(),
    );
  }
}
