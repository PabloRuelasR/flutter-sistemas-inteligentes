import 'package:flutter/material.dart';

class ThemeController {
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  static void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
  }
}
