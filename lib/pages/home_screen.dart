import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/pages/add_todo_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/filter_button.dart';
import 'package:todo/widgets/todo_item.dart';

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final todos = useProvider(hiveTodosProvider);
    final todoFilter = useProvider(todoFilterProvider);
    final searchContoller = useProvider(searchContollerProvider);
    final todosListenable =
        useValueListenable(todos.getTodos().listenable()).values.toList();
    final sortedTodos =
        useProvider(sortedTodosProvider(todosListenable)).toList();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          leading: IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddTodoScreen(
                  isNew: true,
                  todo: null,
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemBuilder: (context, i) {
                Todo todo = sortedTodos[i];
                return TodoItem(todo: todo, i: i);
              },
              itemCount: sortedTodos.length,
            ),
            Column(
              children: [
                Container(
                  color: DARKEST,
                  margin: const EdgeInsets.only(
                    top: 10,
                    right: 10,
                    left: 10,
                  ),
                  child: TextField(
                    onChanged: (v) => searchContoller.state = v,
                    maxLines: 1,
                    minLines: 1,
                    cursorColor: RED,
                    style: TextStyle(
                      color: WHITE,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(labelText: 'Search'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterButton(
                      todoFilter: todoFilter,
                      todoFilterEnum: TodoFilter.all,
                      text: 'All',
                    ),
                    FilterButton(
                      todoFilter: todoFilter,
                      todoFilterEnum: TodoFilter.notDone,
                      text: 'Active',
                    ),
                    FilterButton(
                      todoFilter: todoFilter,
                      todoFilterEnum: TodoFilter.done,
                      text: 'Completed',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
