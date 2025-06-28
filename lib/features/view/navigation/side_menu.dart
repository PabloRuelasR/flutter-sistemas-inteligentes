import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/view/navigation/theme_switch.dart';
import 'menu_header.dart';
import 'menu_list.dart';

class SideMenu extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onSelectMenu;

  const SideMenu({
    super.key,
    required this.selectedMenu,
    required this.onSelectMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const MenuHeader(),
          Expanded(
            child: MenuList(
              selectedMenu: selectedMenu,
              onSelectMenu: onSelectMenu,
            ),
          ),
          const ThemeSwitchTile(),
        ],
      ),
    );
  }
}
