import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/setting_colors.dart';
import 'package:todo/constants/todo_filter.dart';
import 'package:todo/providers/providers.dart';
import 'package:todo/widgets/filter_button.dart';

class TodoListHeader extends HookConsumerWidget {
  const TodoListHeader({
    super.key,
    required this.titleTextEditingContorller,
    required this.descriptionTextEditingContorller,
  });

  final TextEditingController titleTextEditingContorller;
  final TextEditingController descriptionTextEditingContorller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.read(colorNoteProvider);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 25,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => ref.read(colorNoteProvider.notifier).state =
                  SettingsColors.colors[index],
              child: Container(
                width: 40,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: color == SettingsColors.colors[index]
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
            decoration: InputDecoration(
              labelText: 'Title',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color),
              ),
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
            decoration: InputDecoration(
              labelText: 'Description',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color),
              ),
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
            onChanged: (v) =>
                ref.read(todoSearchContollerProvider.notifier).state = v,
            maxLines: 1,
            minLines: 1,
            //cursorColor: RED,
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Search',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterButton(
                todoFilterEnum: TodoFilter.all,
                text: 'All',
              ),
              FilterButton(
                todoFilterEnum: TodoFilter.notDone,
                text: 'Active',
              ),
              FilterButton(
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
