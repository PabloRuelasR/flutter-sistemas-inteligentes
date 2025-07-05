import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/view/navigation/menu_header.dart';
import 'package:flutter_sistemas_inteligentes/features/view/navigation/menu_list.dart';
import 'package:flutter_sistemas_inteligentes/features/view/navigation/theme_switch.dart';

class SideMenu extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onMenuChanged;

  const SideMenu({
    super.key,
    required this.selectedMenu,
    required this.onMenuChanged,
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
              onSelectMenu: onMenuChanged,
            ),
          ),
          const ThemeSwitchTile(),
        ],
      ),
    );
  }
}
