import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/constants/colors.dart';
import 'package:todo/constants/setting_colors.dart';
import 'package:todo/constants/strings.dart';
import 'package:todo/providers/providers.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteListHeader extends HookWidget {
  const NoteListHeader({
    super.key,
    required this.textEditingController,
    required this.searchContoller,
  });

  final TextEditingController textEditingController;
  final StateController<String> searchContoller;

  @override
  Widget build(BuildContext context) {
    final settings = useProvider(hiveSettingsProvider);
    final colorListenable = useValueListenable(
            settings.getSettings()?.listenable() as ValueListenable)
        .get(COLOR);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 25,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => context.read(hiveSettingsProvider).makeSettings(
                    SETTINGS_COLORS[index].value,
                  ), //color.state = SETTINGS_COLORS[index],
              child: Container(
                width: 40,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: colorListenable == SETTINGS_COLORS[index].value
                      ? BorderRadius.circular(10)
                      : BorderRadius.circular(4),
                  color: SETTINGS_COLORS[index],
                ),
              ),
            ),
            itemCount: SETTINGS_COLORS.length,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: DARKEST,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: textEditingController,
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
      ],
    );
  }
}
