import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/setting_colors.dart';
import 'package:todo/constants/strings.dart';
import 'package:todo/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteListHeader extends HookConsumerWidget {
  const NoteListHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(hiveSettingsProvider);
    final colorListenable = useValueListenable(
            settings.getSettings()?.listenable() as ValueListenable)
        .get(MyStrings.color);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 25,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => ref.read(hiveSettingsProvider).makeSettings(
                    SettingsColors.colors[index].value,
                  ),
              child: Container(
                width: 40,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius:
                      colorListenable == SettingsColors.colors[index].value
                          ? BorderRadius.circular(10)
                          : BorderRadius.circular(4),
                  color: SettingsColors.colors[index],
                ),
              ),
            ),
            itemCount: SettingsColors.colors.length,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: MyColors.darkest,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onChanged: (v) =>
                ref.read(noteSearchContollerProvider.notifier).state = v,
            maxLines: 1,
            minLines: 1,
            cursorColor: MyColors.red,
            style: const TextStyle(
              color: MyColors.white,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              labelText: 'Search',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(colorListenable)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
