import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/pages/add_note_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/note_list.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    final searchContoller = useProvider(searchContollerProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          leading: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Uuid uuid = const Uuid();
              String id = uuid.v4();
              await context.read(hiveTodosProvider).openBox(noteId: id);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddNoteScreen(
                    note: null,
                    id: id,
                  ),
                ),
              );
              searchContoller.state = '';
              textEditingController.text = '';
            },
          ),
        ),
        body: NoteList(
          textEditingController: textEditingController,
          searchContoller: searchContoller,
        ),
      ),
    );
  }
}
