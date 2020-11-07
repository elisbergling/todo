import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/setting_colors.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/providers.dart';

class AddTodoScreen extends HookWidget {
  final Todo todo;
  final String noteId;
  final bool isNew;
  AddTodoScreen({@required this.noteId, this.todo, this.isNew});
  @override
  Widget build(BuildContext context) {
    final titleTextEditingContorller =
        useTextEditingController(text: isNew ? '' : todo.title);
    final descriptionTextEditingContorller =
        useTextEditingController(text: isNew ? '' : todo.description);
    final color = useProvider(colorProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Todo newTodo = Todo(
                  title: titleTextEditingContorller.text.trim(),
                  description: descriptionTextEditingContorller.text.trim(),
                  isDone: isNew ? false : todo.isDone,
                  id: isNew ? '' : todo.id,
                  index: isNew ? 0 : todo.index,
                  color: color.state.value,
                );
                context
                    .read(hiveTodosProvider)
                    .makeTodo(noteId: noteId, todo: newTodo, isNew: isNew);
                Navigator.of(context).pop();
              }),
          title: Text('Todo'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                if (!isNew)
                  context
                      .read(hiveTodosProvider)
                      .deleteTodo(noteId: noteId, id: todo.id);
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
                    onTap: () => color.state = SETTINGS_COLORS[index],
                    child: Container(
                      width: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: color.state == SETTINGS_COLORS[index]
                            ? BorderRadius.circular(10)
                            : BorderRadius.circular(4),
                        color: SETTINGS_COLORS[index],
                      ),
                    ),
                  ),
                  itemCount: SETTINGS_COLORS.length,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: titleTextEditingContorller,
                  //cursorColor: RED,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Title',
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
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
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
