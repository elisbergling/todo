import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/note_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/widgets/note_list_header.dart';

class NoteList extends HookWidget {
  const NoteList({
    Key key,
    @required this.textEditingController,
    @required this.searchContoller,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final StateController<String> searchContoller;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final notes = useProvider(hiveNotesProvider);
    final notesListenable =
        useValueListenable(notes.getNotes()?.listenable()).values?.toList();
    final sortedNotes =
        useProvider(sortedNotesProvider(notesListenable))?.toList() ?? [];
    return ReorderableListView(
      header: NoteListHeader(
        textEditingController: textEditingController,
        searchContoller: searchContoller,
      ),
      padding: const EdgeInsets.all(0),
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
    );
  }
}
