import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/note_item.dart';
import 'package:todo/widgets/note_list_header.dart';

class NoteList extends HookConsumerWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();

    final notes = ref.watch(hiveNotesProvider);
    final notesListenable =
        useValueListenable(notes.getNotes()!.listenable()).values.toList();
    final sortedNotes =
        ref.watch(sortedNotesProvider(notesListenable))?.toList() ?? [];
    return ReorderableListView(
      header: const NoteListHeader(),
      padding: const EdgeInsets.all(0),
      onReorder: (oldIndex, newIndex) =>
          ref.read(hiveNotesProvider).updateNotes(
                oldIndex: oldIndex,
                newIndex: newIndex,
                notes: sortedNotes,
              ),
      scrollController: scrollController,
      children: sortedNotes
          .map((note) => NoteItem(
                note: note,
                key: ValueKey(note.id),
              ))
          .toList(),
    );
  }
}
