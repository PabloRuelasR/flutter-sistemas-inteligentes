import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/controllers/theme_controller.dart';
import 'package:flutter_sistemas_inteligentes/routers/app_routes.dart';
import 'package:flutter_sistemas_inteligentes/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Casa Domótica',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          initialRoute: '/',
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
