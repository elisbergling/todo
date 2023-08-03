import 'package:hive/hive.dart';
import 'package:todo/constants/colors.dart';
import '../constants/strings.dart';

class HiveSettings {
  Box<int> settingsBox = Hive.box<int>(MyStrings.settings);

  Box<int>? getSettings() {
    try {
      if (settingsBox.get(MyStrings.color) == null) {
        makeSettings(MyColors.red.value);
      }
      return settingsBox;
    } catch (e) {
      return null;
    }
  }

  int? getColor() {
    try {
      return settingsBox.get(MyStrings.color) ?? MyColors.red.value;
    } catch (e) {
      return null;
    }
  }

  void makeSettings(int color) {
    try {
      settingsBox.put(MyStrings.color, color);
    } catch (e) {
      return;
    }
  }
}
