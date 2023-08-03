import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/add_note_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/constants/colors.dart';

class NoteItem extends HookConsumerWidget {
  const NoteItem({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      key: key,
      onTap: () async {
        await ref.read(hiveTodosProvider).openBox(noteId: note.id);
        ref.read(colorNoteProvider.notifier).state = Color(note.color);
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddNoteScreen(
                note: note,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
                color: MyColors.darkest,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Color(note.color),
                    spreadRadius: 1,
                    blurRadius: 0,
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 42,
                        child: Text(
                          note.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: MyColors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (note.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      note.description,
                      style: const TextStyle(
                        color: MyColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
