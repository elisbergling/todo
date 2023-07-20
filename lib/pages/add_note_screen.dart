import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/add_todo_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/todo_list.dart';

class AddNoteScreen extends HookWidget {
  final Note? note;
  final String? id;
  AddNoteScreen({
    required this.note,
    this.id,
  });
  bool get isNew => note == null;
  @override
  Widget build(BuildContext context) {
    final searchContoller = useProvider(searchContollerProvider);
    final titleTextEditingContorller =
        useTextEditingController(text: isNew ? '' : note!.title);
    final descriptionTextEditingContorller =
        useTextEditingController(text: isNew ? '' : note!.description);
    final color = useProvider(colorProvider);
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
                  id: isNew ? id! : note!.id,
                  index: isNew ? 0 : note!.index,
                  color: color.state.value,
                );
                context
                    .read(hiveNotesProvider)
                    .makeNote(note: newNote, isNew: isNew);
                Navigator.of(context).pop();
                searchContoller.state = '';
              }),
          title: Text('Note'),
          actions: [
            IconButton(
              icon: Icon(Icons.library_add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddTodoScreen(
                      noteId: isNew ? id! : note!.id,
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
                  context.read(hiveNotesProvider).deleteNote(id: note!.id);
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: TodoList(
          color: color,
          titleTextEditingContorller: titleTextEditingContorller,
          descriptionTextEditingContorller: descriptionTextEditingContorller,
          searchContoller: searchContoller,
          id: isNew ? id! : note!.id,
        ),
      ),
    );
  }
}
