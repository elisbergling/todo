import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/pages/add_todo_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/constants/colors.dart';
import 'package:hooks_riverpod/all.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    Key key,
    @required this.todo,
    @required this.i,
  }) : super(key: key);

  final Todo todo;
  final int i;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddTodoScreen(
            isNew: false,
            todo: todo,
            i: i,
          ),
        ),
      ),
      child: Container(
        margin: i == 0
            ? const EdgeInsets.only(top: 80, bottom: 10, left: 10, right: 10)
            : const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: DARKER,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: RED,
                spreadRadius: 3,
                blurRadius: 0,
              ),
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  checkColor: DARKEST,
                  activeColor: RED,
                  value: todo.isDone,
                  onChanged: (_) => context
                      .read(hiveTodosProvider)
                      .toogleIsDoneTodo(i: i, todo: todo),
                ),
                Text(
                  todo.title,
                  style: TextStyle(color: WHITE, fontSize: 20),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                todo.description,
                style: TextStyle(
                  color: WHITE,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
