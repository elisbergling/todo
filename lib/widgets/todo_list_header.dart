import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/setting_colors.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/filter_button.dart';

class TodoListHeader extends HookWidget {
  const TodoListHeader({
    super.key,
    required this.color,
    required this.titleTextEditingContorller,
    required this.descriptionTextEditingContorller,
    required this.searchContoller,
  });

  final StateController<Color> color;
  final TextEditingController titleTextEditingContorller;
  final TextEditingController descriptionTextEditingContorller;
  final StateController<String> searchContoller;

  @override
  Widget build(BuildContext context) {
    final todoFilter = useProvider(todoFilterProvider);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 25,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => color.state = SettingsColors.colors[index],
              child: Container(
                width: 40,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: color.state == SettingsColors.colors[index]
                      ? BorderRadius.circular(10)
                      : BorderRadius.circular(4),
                  color: SettingsColors.colors[index],
                ),
              ),
            ),
            itemCount: SettingsColors.colors.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: titleTextEditingContorller,
            //cursorColor: RED,
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 24,
            ),
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: descriptionTextEditingContorller,
            maxLines: 14,
            minLines: 1,
            //cursorColor: RED,
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
          ),
          decoration: BoxDecoration(
            color: MyColors.darkest,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onChanged: (v) => searchContoller.state = v,
            maxLines: 1,
            minLines: 1,
            //cursorColor: RED,
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 20,
            ),
            decoration: const InputDecoration(labelText: 'Search'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
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
        ),
      ],
    );
  }
}
