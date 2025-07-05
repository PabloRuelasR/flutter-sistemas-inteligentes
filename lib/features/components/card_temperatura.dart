import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/components/dashboard_card.dart';

class CardTemperatura extends StatefulWidget {
  const CardTemperatura({super.key});

  @override
  State<CardTemperatura> createState() => _CardTemperaturaState();
}

class _CardTemperaturaState extends State<CardTemperatura> {
  final DatabaseReference ref =
      FirebaseDatabase.instance.ref('lecturasSensor/Temperatura');

  String valueText = "Sin registro";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final rawData = snapshot.data!.snapshot.value;

          if (rawData is Map<dynamic, dynamic>) {
            String latestTimestamp = "";
            String latestValue = "";

            rawData.forEach((key, value) {
              if (value is Map &&
                  value['timestamp'] != null &&
                  value['valor'] != null) {
                final ts = value['timestamp'].toString();
                if (ts.compareTo(latestTimestamp) > 0) {
                  latestTimestamp = ts;
                  latestValue = value['valor'].toString();
                }
              }
            });

            if (latestValue.isNotEmpty) {
              valueText = "$latestValue°C";
            }
          }
        }

        return DashboardCard(
          title: "Temperatura",
          icon: Icons.thermostat,
          value: valueText,
          color: Colors.orangeAccent,
        );
      },
    );
  }
}
