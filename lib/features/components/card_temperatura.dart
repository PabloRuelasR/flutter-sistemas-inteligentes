import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/components/dashboard_card.dart';

class CardTemperatura extends StatelessWidget {
  const CardTemperatura({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(
      title: "Temperatura",
      icon: Icons.thermostat,
      value: "22°C",
      color: Colors.orangeAccent,
    );
  }
}

