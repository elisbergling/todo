import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/add_note_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/constants/colors.dart';

class NoteItem extends HookWidget {
  const NoteItem({
    super.key,
    required this.note,
    required this.textEditingController,
  });

  final Note note;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final color = useProvider(colorProvider);
    final searchContoller = useProvider(searchContollerProvider);
    return GestureDetector(
      key: key,
      onTap: () async {
        await context.read(hiveTodosProvider).openBox(noteId: note.id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddNoteScreen(
              note: note,
            ),
          ),
        );
        textEditingController.text = '';
        searchContoller.state = '';
        color.state = Color(note.color);
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
                        width: 250,
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
