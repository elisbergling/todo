import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/todo_filter.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    Key key,
    @required this.text,
    @required this.todoFilter,
    @required this.todoFilterEnum,
  }) : super(key: key);

  final StateController<TodoFilter> todoFilter;
  final String text;
  final TodoFilter todoFilterEnum;

  Color textColorForBorder() {
    return todoFilter.state == todoFilterEnum ? RED : WHITE;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10.5),
      height: 40,
      decoration:
          BoxDecoration(color: DARKEST, borderRadius: BorderRadius.circular(5)),
      child: OutlineButton(
        onPressed: () => todoFilter.state = todoFilterEnum,
        borderSide: BorderSide(color: textColorForBorder()),
        visualDensity: VisualDensity.standard,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: WHITE, fontSize: 16),
        ),
      ),
    );
  }
}
