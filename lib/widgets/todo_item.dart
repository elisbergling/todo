import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/pages/add_todo_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/constants/colors.dart';

class TodoItem extends HookWidget {
  const TodoItem({
    super.key,
    required this.noteId,
    required this.todo,
  });

  final Todo todo;
  final String noteId;

  @override
  Widget build(BuildContext context) {
    final color = useProvider(colorProvider);
    return GestureDetector(
      key: key,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AddTodoScreen(
              noteId: noteId,
              todo: todo,
            ),
          ),
        );
        color.state = Color(todo.color);
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
                    color: Color(todo.color),
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
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      checkColor: MyColors.darkest,
                      activeColor: Color(todo.color),
                      value: todo.isDone,
                      onChanged: (_) => context
                          .read(hiveTodosProvider)
                          .toogleIsDoneTodo(noteId: noteId, todo: todo),
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(
                        todo.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: MyColors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                if (todo.description != '')
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      todo.description,
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
