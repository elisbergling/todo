import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/note_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/widgets/note_list_header.dart';

class NoteList extends HookWidget {
  const NoteList({
    super.key,
    required this.textEditingController,
    required this.searchContoller,
  });

  final TextEditingController textEditingController;
  final StateController<String> searchContoller;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final notes = useProvider(hiveNotesProvider);
    final notesListenable =
        useValueListenable(notes.getNotes()?.listenable() as ValueListenable)
            .values
            .toList();
    final sortedNotes =
        useProvider(sortedNotesProvider(notesListenable))?.toList() ?? [];
    return ReorderableListView(
      header: NoteListHeader(
        textEditingController: textEditingController,
        searchContoller: searchContoller,
      ),
      padding: const EdgeInsets.all(0),
      onReorder: (oldIndex, newIndex) =>
          context.read(hiveNotesProvider).updateNotes(
                oldIndex: oldIndex,
                newIndex: newIndex,
                notes: sortedNotes,
              ),
      scrollController: scrollController,
      children: sortedNotes
          .map((note) => NoteItem(
                textEditingController: textEditingController,
                note: note,
                key: ValueKey(note.id),
              ))
          .toList(),
    );
  }
}
