import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/setting_colors.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/add_todo_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/widgets/filter_button.dart';
import 'package:todo/widgets/todo_item.dart';

class AddNoteScreen extends HookWidget {
  final Note note;
  final bool isNew;
  AddNoteScreen({this.note, this.isNew});
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final todos = useProvider(hiveTodosProvider);
    final todoFilter = useProvider(todoFilterProvider);
    final searchContoller = useProvider(searchContollerProvider);
    final todosListenable =
        useValueListenable(todos.getTodos(noteId: note.id)?.listenable())
            .values
            ?.toList();
    final sortedTodos =
        useProvider(sortedTodosProvider(todosListenable))?.toList() ?? [];
    //final todoColor = useProvider(todoColorProvider);
    //
    //
    //
    final titleTextEditingContorller =
        useTextEditingController(text: isNew ? '' : note.title);
    final descriptionTextEditingContorller =
        useTextEditingController(text: isNew ? '' : note.description);
    final todoColor = useProvider(todoColorProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Note newNote = Note(
                  title: titleTextEditingContorller.text.trim(),
                  description: descriptionTextEditingContorller.text.trim(),
                  id: note.id,
                  index: isNew ? 0 : note.index,
                  color: todoColor.state.value,
                );
                context
                    .read(hiveNotesProvider)
                    .makeNote(note: newNote, isNew: isNew);
                Navigator.of(context).pop();
                searchContoller.state = '';
              }),
          title: Text(isNew ? 'Add a Note' : note.title),
          actions: [
            IconButton(
              icon: Icon(Icons.library_add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddTodoScreen(
                      noteId: note.id,
                      isNew: true,
                      todo: null,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (!isNew)
                  context.read(hiveNotesProvider).deleteNote(id: note.id);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: ReorderableListView(
          header: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 25,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => todoColor.state = SETTINGS_COLORS[index],
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: todoColor.state == SETTINGS_COLORS[index]
                            ? BorderRadius.circular(10)
                            : BorderRadius.circular(4),
                        color: SETTINGS_COLORS[index],
                      ),
                    ),
                  ),
                  itemCount: SETTINGS_COLORS.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: titleTextEditingContorller,
                  cursorColor: RED,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: descriptionTextEditingContorller,
                  maxLines: 14,
                  minLines: 1,
                  cursorColor: RED,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  right: 10,
                  left: 10,
                ),
                decoration: BoxDecoration(
                    color: DARKEST, borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  onChanged: (v) => searchContoller.state = v,
                  maxLines: 1,
                  minLines: 1,
                  cursorColor: RED,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(labelText: 'Search'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilterButton(
                    todoFilter: todoFilter,
                    todoFilterEnum: TodoFilter.all,
                    text: 'All',
                  ),
                  FilterButton(
                    todoFilter: todoFilter,
                    todoFilterEnum: TodoFilter.notDone,
                    text: 'Active',
                  ),
                  FilterButton(
                    todoFilter: todoFilter,
                    todoFilterEnum: TodoFilter.done,
                    text: 'Completed',
                  ),
                ],
              ),
            ],
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
        ), /*SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                height: 25,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => todoColor.state = SETTINGS_COLORS[index],
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: todoColor.state == SETTINGS_COLORS[index]
                            ? BorderRadius.circular(10)
                            : BorderRadius.circular(4),
                        color: SETTINGS_COLORS[index],
                      ),
                    ),
                  ),
                  itemCount: SETTINGS_COLORS.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: titleTextEditingContorller,
                  cursorColor: RED,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: descriptionTextEditingContorller,
                  maxLines: 14,
                  minLines: 1,
                  cursorColor: RED,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
              ),
            ],
          ),
        ),*/
      ),
    );
  }
}
