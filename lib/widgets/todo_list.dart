import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/models/note.dart';
import 'package:todo/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/widgets/todo_item.dart';
import 'package:todo/widgets/todo_list_header.dart';

class TodoList extends HookWidget {
  const TodoList({
    Key key,
    @required this.color,
    @required this.titleTextEditingContorller,
    @required this.descriptionTextEditingContorller,
    @required this.searchContoller,
    @required this.note,
  }) : super(key: key);

  final StateController<Color> color;
  final TextEditingController titleTextEditingContorller;
  final TextEditingController descriptionTextEditingContorller;
  final StateController<String> searchContoller;
  final Note note;

  @override
  Widget build(BuildContext context) {
    final todos = useProvider(hiveTodosProvider);
    final todosListenable =
        useValueListenable(todos.getTodos(noteId: note.id)?.listenable())
            .values
            ?.toList();
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
      children: sortedTodos
          .map((e) => TodoItem(
                todo: e,
                noteId: note.id,
                key: ValueKey(e.id),
              ))
          .toList(),
      onReorder: (oldIndex, newIndex) =>
          context.read(hiveTodosProvider).updateTodos(
                noteId: note.id,
                oldIndex: oldIndex,
                newIndex: newIndex,
                todos: sortedTodos,
              ),
      scrollController: scrollController,
    );
  }
}
