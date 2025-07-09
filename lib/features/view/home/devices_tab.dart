import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DevicesTab extends StatefulWidget {
  const DevicesTab({super.key});

  @override
  State<DevicesTab> createState() => _DevicesTabState();
}

class _DevicesTabState extends State<DevicesTab> {
  final DatabaseReference _ledRef = FirebaseDatabase.instance.ref('ledControl');
  bool _ledState = false;

  @override
  void initState() {
    super.initState();

    // Escuchar cambios en tiempo real desde Firebase
    _ledRef.onValue.listen((event) {
      final val = event.snapshot.value;
      if (val != null && mounted) {
        setState(() {
          _ledState = val == 1;
        });
      }
    });
  }

  void _toggleLed(bool value) {
    _ledRef.set(value ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.lightbulb_outline, color: Colors.amber),
          title: const Text("Foco Sala"),
          subtitle: Text(_ledState ? "Encendido" : "Apagado"),
          trailing: Switch(
            value: _ledState,
            onChanged: _toggleLed,
          ),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.sensors, color: Colors.blue),
          title: Text("Sensor de Puerta"),
          subtitle: Text("Cerrada"),
          trailing: Icon(Icons.lock_outline),
        ),
      ],
    );
  }
}
