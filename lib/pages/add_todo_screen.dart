import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/providers/providers.dart';

class AddTodoScreen extends HookWidget {
  final Todo todo;
  final int i;
  final bool isNew;
  AddTodoScreen({this.todo, this.isNew, this.i});
  @override
  Widget build(BuildContext context) {
    final titleTextEditingContorller =
        useTextEditingController(text: isNew ? '' : todo.title);
    final descriptionTextEditingContorller =
        useTextEditingController(text: isNew ? '' : todo.description);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: DARKEST,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: RED,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Todo newTodo = Todo(
                  title: titleTextEditingContorller.text.trim(),
                  description: descriptionTextEditingContorller.text.trim(),
                  isDone: isNew ? false : todo.isDone,
                );
                isNew
                    ? context.read(hiveTodosProvider).createTodo(todo: newTodo)
                    : context
                        .read(hiveTodosProvider)
                        .updateTodo(i: i, todo: newTodo);
                Navigator.of(context).pop();
              }),
          title: Text('Add a Todo'),
          actions: [
            if (!isNew)
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    context.read(hiveTodosProvider).deleteTodo(i: i);
                    Navigator.of(context).pop();
                  })
          ],
        ),
        body: SingleChildScrollView(
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: titleTextEditingContorller,
                  maxLength: 30,
                  maxLines: 2,
                  minLines: 1,
                  cursorColor: RED,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: RED),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: WHITE),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ERROR_COLOR),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ERROR_COLOR),
                    ),
                    labelText: 'Title',
                    labelStyle: TextStyle(color: WHITE),
                    helperStyle: TextStyle(color: WHITE),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: TextField(
                  controller: descriptionTextEditingContorller,
                  maxLength: 3000,
                  maxLines: 18,
                  minLines: 1,
                  scrollPhysics: PageScrollPhysics(),
                  cursorColor: RED,
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: RED),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: WHITE),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ERROR_COLOR),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ERROR_COLOR),
                    ),
                    labelText: 'Description',
                    labelStyle: TextStyle(color: WHITE),
                    helperStyle: TextStyle(color: WHITE),
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
