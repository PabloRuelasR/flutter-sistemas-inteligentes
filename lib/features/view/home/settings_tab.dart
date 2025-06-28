import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/view/navigation/theme_switch.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.person_outline),
          title: Text("Perfil"),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.notifications_none),
          title: Text("Notificaciones"),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
        Divider(),
        ThemeSwitchTile(),
      ],
    );
  }
}
