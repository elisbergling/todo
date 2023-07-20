import 'package:hive/hive.dart';
import 'package:todo/constants/colors.dart';
import '../constants/strings.dart';

class HiveSettings {
  Box<int> settingsBox = Hive.box<int>(SETTINGS);

  Box<int>? getSettings() {
    try {
      if (settingsBox.get(COLOR) == null) {
        makeSettings(RED.value);
      }
      return settingsBox;
    } catch (e) {
      print(e);
      return null;
    }
  }

  int? getColor() {
    try {
      return settingsBox.get(COLOR) ?? RED.value;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void makeSettings(int color) {
    try {
      settingsBox.put(COLOR, color);
    } catch (e) {
      print(e);
    }
  }
}
