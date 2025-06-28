import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/components/dashboard_card.dart';

class CardHumedad extends StatelessWidget {
  const CardHumedad({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardCard(
      title: "Humedad",
      icon: Icons.water_drop,
      value: "45%",
      color: Colors.blueAccent,
    );
  }
}

