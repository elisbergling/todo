import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
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
  List<Todo> func(List<Todo> t, StateController<TodoFilter> todoFilter) {
    switch (todoFilter.state) {
      case TodoFilter.done:
        return t.where((todo) => todo.isDone).toList();
      case TodoFilter.notDone:
        return t.where((todo) => !todo.isDone).toList();
      case TodoFilter.all:
      default:
        return t;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todos = useProvider(hiveTodosProvider);
    final todoFilter = useProvider(todoFilterProvider);
    return Scaffold(
      backgroundColor: DARKEST,
      appBar: AppBar(
        backgroundColor: RED,
        elevation: 0,
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddTodoScreen(
                isNew: true,
                todo: null,
                i: null,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: todos.getTodos().listenable(),
            builder: (context, Box<Todo> tB, _) {
              final t = func(tB.values.toList(), todoFilter);
              return ListView.builder(
                itemBuilder: (context, i) {
                  Todo todo = t[i];
                  return TodoItem(todo: todo, i: i);
                },
                itemCount: t.length,
              );
            },
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
    );
  }
}
