import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/add_note_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/note_item.dart';
import 'package:uuid/uuid.dart';

/*

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final todos = useProvider(hiveTodosProvider);
    final todoFilter = useProvider(todoFilterProvider);
    final searchContoller = useProvider(searchContollerProvider);
    final todosListenable =
        useValueListenable(todos.getTodos()?.listenable()).values?.toList();
    final sortedTodos =
        useProvider(sortedTodosProvider(todosListenable))?.toList() ?? [];
    final todoColor = useProvider(todoColorProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Todos'),
          leading: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddTodoScreen(
                      isNew: true,
                      todo: null,
                    ),
                  ),
                );
                todoColor.state = RED;
              }),
        ),
        body: ReorderableListView(
          header: Column(
            children: [
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
                    key: ValueKey(e.id),
                  ))
              .toList(),
          onReorder: (oldIndex, newIndex) =>
              context.read(hiveTodosProvider).updateTodos(
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                    todos: sortedTodos,
                  ),
          scrollController: scrollController,
        ),
      ),
    );
  }
}

*/

class HomeScreenTest extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    final scrollController = useScrollController();
    final searchContoller = useProvider(searchContollerProvider);
    final notes = useProvider(hiveNotesProvider);
    final notesListenable =
        useValueListenable(notes.getNotes()?.listenable()).values?.toList();
    final sortedNotes =
        useProvider(sortedNotesProvider(notesListenable))?.toList() ?? [];
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Notes'),
          leading: IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Uuid uuid = Uuid();
              Note note = Note(id: uuid.v4());
              await context.read(hiveTodosProvider).openBox(noteId: note.id);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddNoteScreen(
                    isNew: true,
                    note: note,
                  ),
                ),
              );
              searchContoller.state = '';
              textEditingController.text = '';
            },
          ),
        ),
        body: ReorderableListView(
          header: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DARKEST,
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              controller: textEditingController,
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
          children: sortedNotes
              .map((note) => NoteItem(
                    textEditingController: textEditingController,
                    note: note,
                    key: ValueKey(note.id),
                  ))
              .toList(),
          onReorder: (oldIndex, newIndex) =>
              context.read(hiveNotesProvider).updateNotes(
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                    notes: sortedNotes,
                  ),
          scrollController: scrollController,
        ),
      ),
    );
  }
}
