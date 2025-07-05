import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/view/navigation/menu_config.dart';

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
    return ListView(
      children: [
        for (var item in menuItems)
          ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            selected: selectedMenu == item.title,
            selectedTileColor: Colors.grey.shade300,
            onTap: () {
              Navigator.pop(context);
              onSelectMenu(item.title);
            },
          ),
      ],
    );
  }
}
