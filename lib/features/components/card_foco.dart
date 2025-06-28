import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/components/dashboard_card.dart';

class CardFoco extends StatelessWidget {
  const CardFoco({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(
      title: "Foco",
      icon: Icons.lightbulb,
      value: "Encendido",
      color: Colors.yellow
    );
  }
}

