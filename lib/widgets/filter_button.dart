import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/providers/providers.dart';

class FilterButton extends HookConsumerWidget {
  const FilterButton({
    super.key,
    required this.text,
    required this.todoFilterEnum,
  });

  final String text;
  final TodoFilter todoFilterEnum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoFilter = ref.watch(todoFilterProvider);
    final color = ref.watch(colorNoteProvider);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 6, left: 5, right: 5),
        height: 40,
        decoration: BoxDecoration(
            color: MyColors.darkest, borderRadius: BorderRadius.circular(5)),
        child: OutlinedButton(
          onPressed: () =>
              ref.read(todoFilterProvider.notifier).state = todoFilterEnum,
          style: ButtonStyle(
            visualDensity: VisualDensity.standard,
            side: MaterialStateProperty.all(
              BorderSide(
                color: todoFilter == todoFilterEnum ? color : MyColors.white,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: MyColors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
