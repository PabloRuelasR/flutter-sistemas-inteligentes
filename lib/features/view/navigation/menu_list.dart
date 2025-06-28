import 'package:flutter/material.dart';

class MenuList extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onSelectMenu;

  const MenuList({
    super.key,
    required this.selectedMenu,
    required this.onSelectMenu,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = ["Inicio", "Buscar", "Historial", "Configuración"];

    return ListView(
      children: [
        for (var item in menuItems)
          ListTile(
            leading: Icon(_getIcon(item)),
            title: Text(item),
            selected: selectedMenu == item,
            selectedTileColor: Colors.grey.shade300,
            onTap: () => onSelectMenu(item),
          ),
      ],
    );
  }

  IconData _getIcon(String item) {
    switch (item) {
      case "Inicio":
        return Icons.home;
      case "Buscar":
        return Icons.search;
      case "Historial":
        return Icons.history;
      case "Configuración":
        return Icons.settings;
      default:
        return Icons.circle;
    }
  }
}
