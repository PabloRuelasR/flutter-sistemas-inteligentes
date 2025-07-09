import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_sistemas_inteligentes/features/components/dashboard_card.dart';

class CardFoco extends StatefulWidget {
  const CardFoco({super.key});

  @override
  State<CardFoco> createState() => _CardFocoState();
}

class _CardFocoState extends State<CardFoco> {
  final DatabaseReference _ledRef = FirebaseDatabase.instance.ref('ledControl');
  bool _ledState = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    // Escuchar cambios en tiempo real
    _ledRef.onValue.listen((event) {
      final val = event.snapshot.value;
      if (val != null && mounted) {
        setState(() {
          _ledState = val == 1;
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DashboardCard(
      title: "Foco",
      icon: _ledState ? Icons.lightbulb : Icons.lightbulb_outline,
      value: _ledState ? "Encendido" : "Apagado",
      color: _ledState ? Colors.yellow : Colors.grey,
    );
  }
}
