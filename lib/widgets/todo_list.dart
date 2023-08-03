import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/todo_item.dart';
import 'package:todo/widgets/todo_list_header.dart';

class TodoList extends HookConsumerWidget {
  const TodoList({
    super.key,
    required this.titleTextEditingContorller,
    required this.descriptionTextEditingContorller,
    required this.searchContoller,
    required this.id,
  });

  final TextEditingController titleTextEditingContorller;
  final TextEditingController descriptionTextEditingContorller;
  final StateController<String> searchContoller;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(hiveTodosProvider);
    final todosListenable =
        useValueListenable(todos.getTodos(noteId: id)!.listenable())
            .values
            .toList();
    final sortedTodos =
        ref.watch(sortedTodosProvider(todosListenable))?.toList() ?? [];
    final scrollController = useScrollController();
    return ReorderableListView(
      header: TodoListHeader(
        titleTextEditingContorller: titleTextEditingContorller,
        descriptionTextEditingContorller: descriptionTextEditingContorller,
      ),
      onReorder: (oldIndex, newIndex) =>
          ref.read(hiveTodosProvider).updateTodos(
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
