import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/view/home/home_page.dart';
import 'package:flutter_sistemas_inteligentes/features/view/splash/splash_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => SplashScreen(),
    '/home': (context) => HomePage(),
  };
}
