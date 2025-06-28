import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/controllers/theme_controller.dart';

class ThemeSwitchTile extends StatefulWidget {
  const ThemeSwitchTile({super.key});

  @override
  State<ThemeSwitchTile> createState() => _ThemeSwitchTileState();
}

class _ThemeSwitchTileState extends State<ThemeSwitchTile> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeController.themeMode,
      builder: (context, ThemeMode mode, _) {
        bool isDark = mode == ThemeMode.dark;

        return SwitchListTile(
          title: const Text("Modo Oscuro"),
          secondary: const Icon(Icons.dark_mode),
          value: isDark,
          onChanged: (value) {
            ThemeController.toggleTheme();
          },
        );
      },
    );
  }
}
