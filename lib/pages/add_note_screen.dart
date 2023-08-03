import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/add_todo_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/todo_list.dart';

class AddNoteScreen extends HookConsumerWidget {
  final Note? note;
  final String? id;
  const AddNoteScreen({
    super.key,
    required this.note,
    this.id,
  });
  bool get isNew => note == null;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchContoller = ref.watch(todoSearchContollerProvider.notifier);
    final titleTextEditingContorller =
        useTextEditingController(text: isNew ? '' : note!.title);
    final descriptionTextEditingContorller =
        useTextEditingController(text: isNew ? '' : note!.description);
    final color = ref.watch(colorNoteProvider);
    final textColor =
        color.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () {
                Note newNote = Note(
                  title: titleTextEditingContorller.text.trim(),
                  description: descriptionTextEditingContorller.text.trim(),
                  id: isNew ? id! : note!.id,
                  index: isNew ? 0 : note!.index,
                  color: color.value,
                );
                ref
                    .read(hiveNotesProvider)
                    .makeNote(note: newNote, isNew: isNew);
                Navigator.of(context).pop();
                ref.read(todoSearchContollerProvider.notifier).state = '';
              }),
          title: Text(
            titleTextEditingContorller.value.text,
            style: TextStyle(
              color: textColor,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.library_add, color: textColor),
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
              icon: Icon(
                Icons.delete,
                color: textColor,
              ),
              onPressed: () {
                if (!isNew) {
                  ref.read(hiveNotesProvider).deleteNote(id: note!.id);
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: TodoList(
          titleTextEditingContorller: titleTextEditingContorller,
          descriptionTextEditingContorller: descriptionTextEditingContorller,
          id: isNew ? id! : note!.id,
          searchContoller: searchContoller,
        ),
      ),
    );
  }
}
