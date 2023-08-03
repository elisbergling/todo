import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/strings.dart';
import 'package:todo/pages/add_note_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/note_list.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(hiveSettingsProvider);
    final colorListenable =
        useValueListenable(settings.getSettings()!.listenable())
            .get(MyStrings.color);
    final textColor = Color(colorListenable!).computeLuminance() < 0.5
        ? MyColors.white
        : MyColors.darkest;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(colorListenable),
          title: Text(
            'Your Collectons',
            style: TextStyle(color: textColor),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.add,
              color: textColor,
            ),
            onPressed: () async {
              Uuid uuid = const Uuid();
              String id = uuid.v4();
              await ref.read(hiveTodosProvider).openBox(noteId: id);
              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddNoteScreen(
                      note: null,
                      id: id,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        body: const NoteList(),
      ),
    );
  }
}
