import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/providers.dart';

class AddTodoScreen extends HookWidget {
  final Todo todo;
  final bool isNew;
  AddTodoScreen({this.todo, this.isNew});
  @override
  Widget build(BuildContext context) {
    final titleTextEditingContorller =
        useTextEditingController(text: isNew ? '' : todo.title);
    final descriptionTextEditingContorller =
        useTextEditingController(text: isNew ? '' : todo.description);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //backgroundColor: DARKEST,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Todo newTodo = Todo(
                  title: titleTextEditingContorller.text.trim(),
                  description: descriptionTextEditingContorller.text.trim(),
                  isDone: isNew ? false : todo.isDone,
                  id: isNew ? '' : todo.id,
                );
                context
                    .read(hiveTodosProvider)
                    .makeTodo(todo: newTodo, isNew: isNew);
                Navigator.of(context).pop();
              }),
          title: Text('Add a Todo'),
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  if (!isNew)
                    context.read(hiveTodosProvider).deleteTodo(id: todo.id);
                  Navigator.of(context).pop();
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: titleTextEditingContorller,
                  maxLength: 30,
                  maxLines: 1,
                  minLines: 1,
                  cursorColor: RED,
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
                padding: const EdgeInsets.only(
                  bottom: 10,
                  left: 10,
                  right: 10,
                ),
                child: TextField(
                  controller: descriptionTextEditingContorller,
                  maxLength: 3000,
                  maxLines: 18,
                  minLines: 1,
                  cursorColor: RED,
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
