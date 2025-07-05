import 'package:flutter/material.dart';

class MenuItemConfig {
  final String title;
  final IconData icon;

  MenuItemConfig({
    required this.title,
    required this.icon,
  });
}

final List<MenuItemConfig> menuItems = [
  MenuItemConfig(title: "Inicio", icon: Icons.home),
 // MenuItemConfig(title: "Buscar", icon: Icons.search),
 // MenuItemConfig(title: "Historial", icon: Icons.history),
   MenuItemConfig(title: "Reportes", icon: Icons.insert_chart),
  MenuItemConfig(title: "Configuración", icon: Icons.settings),
];
