import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/components/dashboard_card.dart';

class CardHumedad extends StatefulWidget {
  const CardHumedad({super.key});

  @override
  State<CardHumedad> createState() => _CardHumedadState();
}

class _CardHumedadState extends State<CardHumedad> {
  final DatabaseReference ref =
      FirebaseDatabase.instance.ref('lecturasSensor/Humedad');

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
              valueText = "$latestValue%";
            }
          }
        }

        return DashboardCard(
          title: "Humedad",
          icon: Icons.water_drop,
          value: valueText,
          color: Colors.blueAccent,
        );
      },
    );
  }
}
