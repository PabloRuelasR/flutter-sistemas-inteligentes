import 'package:flutter/material.dart';

class DevicesTab extends StatelessWidget {
  const DevicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ListTile(
          leading: Icon(Icons.lightbulb_outline, color: Colors.amber),
          title: Text("Foco Sala"),
          subtitle: Text("Encendido"),
          trailing: Switch(value: true, onChanged: null),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.sensors, color: Colors.blue),
          title: Text("Sensor de Puerta"),
          subtitle: Text("Cerrada"),
          trailing: Icon(Icons.lock_outline),
        ),
        Divider(),
        // ListTile(
        //   leading: Icon(Icons.device_thermostat, color: Colors.red),
        //   title: Text("Calefacción"),
        //   subtitle: Text("Apagado"),
        //   trailing: Switch(value: false, onChanged: null),
        // ),
      ],
    );
  }
}
