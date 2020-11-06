import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/strings.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/pages/add_todo_screen.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/filter_button.dart';
import 'package:todo/widgets/todo_item.dart';

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final todos = useProvider(hiveTodosProvider);
    final todoFilter = useProvider(todoFilterProvider);
    final searchContoller = useProvider(searchContollerProvider);
    final todosListenable =
        useValueListenable(todos.getTodos()?.listenable()).values?.toList();
    final sortedTodos =
        useProvider(sortedTodosProvider(todosListenable))?.toList() ?? [];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Todos'),
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
        body: true
            ? TodoList(
                searchContoller: searchContoller,
                todoFilter: todoFilter,
                sortedTodos: sortedTodos,
                scrollController: scrollController,
              )
            : TestTodoList(
                scrollController: scrollController,
                sortedTodos: sortedTodos,
                searchContoller: searchContoller,
                todoFilter: todoFilter,
              ),
      ),
    );
  }
}

class TestTodoList extends StatelessWidget {
  const TestTodoList({
    Key key,
    @required this.searchContoller,
    @required this.todoFilter,
    @required this.sortedTodos,
    @required this.scrollController,
  }) : super(key: key);

  final StateController<String> searchContoller;
  final StateController<TodoFilter> todoFilter;
  final List<Todo> sortedTodos;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ImplicitlyAnimatedReorderableList<Todo>(
      shrinkWrap: true,
      controller: scrollController,
      areItemsTheSame: (newTodo, oldTodo) => newTodo.id == oldTodo.id,
      items: sortedTodos,
      onReorderFinished: (todo, from, to, newTodos) => context
          .read(hiveTodosProvider)
          .updateTodos(newIndex: to, oldIndex: from, todos: sortedTodos),
      spawnIsolate: true,
      header: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
            ),
            decoration: BoxDecoration(
                color: DARKEST, borderRadius: BorderRadius.circular(5)),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      itemBuilder: (context, itemAnimation, todo, i) {
        return Reorderable(
          key: ValueKey(todo.id),
          builder: (context, dragAnimation, inDrag) {
            return ScaleTransition(
              scale: Tween<double>(begin: 1, end: 1.02).animate(dragAnimation),
              child: TodoItem(
                todo: todo,
                isTest: true,
                elvation: dragAnimation.value * 8,
              ),
            );
          },
        );
      },
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({
    Key key,
    @required this.searchContoller,
    @required this.todoFilter,
    @required this.sortedTodos,
    @required this.scrollController,
  }) : super(key: key);

  final StateController<String> searchContoller;
  final StateController<TodoFilter> todoFilter;
  final List<Todo> sortedTodos;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      header: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
            ),
            decoration: BoxDecoration(
                color: DARKEST, borderRadius: BorderRadius.circular(5)),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      children: sortedTodos
          .map((e) => TodoItem(
                todo: e,
                isTest: false,
                key: ValueKey(e.id),
              ))
          .toList(),
      onReorder: (oldIndex, newIndex) =>
          context.read(hiveTodosProvider).updateTodos(
                oldIndex: oldIndex,
                newIndex: newIndex,
                todos: sortedTodos,
              ),
      scrollController: scrollController,
    );
  }
}
