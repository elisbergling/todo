import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/strings.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FilterButton extends HookWidget {
  const FilterButton({
    Key key,
    @required this.text,
    @required this.todoFilter,
    @required this.todoFilterEnum,
  }) : super(key: key);

  final StateController<TodoFilter> todoFilter;
  final String text;
  final TodoFilter todoFilterEnum;

  Color textColorForBorder(int color) {
    return todoFilter.state == todoFilterEnum ? Color(color) : WHITE;
  }

  @override
  Widget build(BuildContext context) {
    final settings = useProvider(hiveSettingsProvider);
    final colorListenable =
        useValueListenable(settings.getSettings()?.listenable()).get(COLOR);
    return Container(
      margin:
          const EdgeInsets.only(top: 15, bottom: 6, left: 10.5, right: 10.5),
      height: 40,
      decoration:
          BoxDecoration(color: DARKEST, borderRadius: BorderRadius.circular(5)),
      child: OutlineButton(
        onPressed: () => todoFilter.state = todoFilterEnum,
        borderSide: BorderSide(color: textColorForBorder(colorListenable)),
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
