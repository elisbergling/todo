import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/pages/add_todo_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/constants/colors.dart';
import 'package:hooks_riverpod/all.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    Key key,
    double elvation,
    @required this.todo,
    @required this.isTest,
  })  : elevation = elvation ?? 0,
        super(key: key);

  final Todo todo;
  final bool isTest;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey(todo.id),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddTodoScreen(
            isNew: false,
            todo: todo,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            //margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),

            decoration: BoxDecoration(
                color: DARKEST,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: RED,
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
                    if (isTest)
                      Handle(child: Icon(Icons.airline_seat_legroom_extra)),
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      checkColor: DARKEST,
                      activeColor: RED,
                      value: todo.isDone,
                      onChanged: (_) => context
                          .read(hiveTodosProvider)
                          .toogleIsDoneTodo(todo: todo),
                    ),
                    Container(
                      width: 250,
                      child: Text(
                        todo.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: WHITE, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                if (todo.description != '')
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
        ),
      ),
    );
  }
}
