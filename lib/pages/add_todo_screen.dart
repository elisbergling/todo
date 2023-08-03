import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/setting_colors.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/providers.dart';

class AddTodoScreen extends HookConsumerWidget {
  final Todo? todo;
  final String noteId;
  const AddTodoScreen({
    super.key,
    required this.noteId,
    required this.todo,
  });

  bool get isNew => todo == null;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleTextEditingContorller =
        useTextEditingController(text: isNew ? '' : todo!.title);
    final descriptionTextEditingContorller =
        useTextEditingController(text: isNew ? '' : todo!.description);
    final color = ref.watch(colorTodoProvider);
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
                Todo newTodo = Todo(
                  title: titleTextEditingContorller.text.trim(),
                  description: descriptionTextEditingContorller.text.trim(),
                  isDone: isNew ? false : todo!.isDone,
                  id: isNew ? '' : todo!.id,
                  index: isNew ? 0 : todo!.index,
                  color: color.value,
                );
                ref
                    .read(hiveTodosProvider)
                    .makeTodo(noteId: noteId, todo: newTodo, isNew: isNew);
                Navigator.of(context).pop();
              }),
          title: Text(
            titleTextEditingContorller.value.text,
            style: TextStyle(color: textColor),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete, color: textColor),
              onPressed: () {
                if (!isNew) {
                  ref
                      .read(hiveTodosProvider)
                      .deleteTodo(noteId: noteId, id: todo!.id);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: 25,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => ref.read(colorTodoProvider.notifier).state =
                        SettingsColors.colors[index],
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: color == SettingsColors.colors[index]
                            ? BorderRadius.circular(10)
                            : BorderRadius.circular(4),
                        color: SettingsColors.colors[index],
                      ),
                    ),
                  ),
                  itemCount: SettingsColors.colors.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: titleTextEditingContorller,
                  //cursorColor: RED,
                  style: const TextStyle(
                    color: MyColors.white,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: descriptionTextEditingContorller,
                  maxLines: 14,
                  minLines: 1,
                  //cursorColor: RED,
                  style: const TextStyle(
                    color: MyColors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: color),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
