import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/add_note_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/constants/colors.dart';
import 'package:hooks_riverpod/all.dart';

class NoteItem extends HookWidget {
  const NoteItem({
    Key key,
    @required this.note,
    @required this.textEditingController,
  }) : super(key: key);

  final Note note;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final todoColor = useProvider(todoColorProvider);
    final searchContoller = useProvider(searchContollerProvider);
    return GestureDetector(
      key: key,
      onTap: () async {
        await context.read(hiveTodosProvider).openBox(noteId: note.id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddNoteScreen(
              isNew: false,
              note: note,
            ),
          ),
        );
        textEditingController.text = '';
        searchContoller.state = '';
        todoColor.state = Color(note.color);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            decoration: BoxDecoration(
                color: DARKEST,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Color(note.color) ?? RED,
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
                      child: Container(
                        width: 250,
                        child: Text(
                          note.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: WHITE, fontSize: 20),
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
                      style: TextStyle(
                        color: WHITE,
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
