import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/components/dashboard_card.dart';

class CardClimaResumen extends StatefulWidget {
  const CardClimaResumen({super.key});

  @override
  State<CardClimaResumen> createState() => _CardClimaResumenState();
}

class _CardClimaResumenState extends State<CardClimaResumen> {
  final DatabaseReference tempRef =
      FirebaseDatabase.instance.ref('lecturasSensor/Temperatura');
  final DatabaseReference humRef =
      FirebaseDatabase.instance.ref('lecturasSensor/Humedad');

  String tempActual = "–";
  String humedadActual = "–";
  String tempMax = "–";
  String tempMin = "–";
  IconData icono = Icons.help_outline;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  void cargarDatos() {
    tempRef.onValue.listen((event) {
      final rawData = event.snapshot.value;
      if (rawData is Map<dynamic, dynamic>) {
        String latestTs = "";
        String latestVal = "";
        double maxVal = double.negativeInfinity;
        double minVal = double.infinity;

        rawData.forEach((key, value) {
          if (value is Map &&
              value['timestamp'] != null &&
              value['valor'] != null) {
            final ts = value['timestamp'].toString();
            final val = double.tryParse(value['valor'].toString()) ?? 0;
            if (ts.compareTo(latestTs) > 0) {
              latestTs = ts;
              latestVal = value['valor'].toString();
            }
            if (val > maxVal) maxVal = val;
            if (val < minVal) minVal = val;
          }
        });

        setState(() {
          tempActual = latestVal.isNotEmpty ? "$latestVal°C" : "–";
          tempMax = maxVal != double.negativeInfinity ? "${maxVal.toStringAsFixed(1)}°C" : "–";
          tempMin = minVal != double.infinity ? "${minVal.toStringAsFixed(1)}°C" : "–";
          icono = obtenerIconoClima(latestVal);
        });
      }
    });

    humRef.onValue.listen((event) {
      final rawData = event.snapshot.value;
      if (rawData is Map<dynamic, dynamic>) {
        String latestTs = "";
        String latestVal = "";

        rawData.forEach((key, value) {
          if (value is Map &&
              value['timestamp'] != null &&
              value['valor'] != null) {
            final ts = value['timestamp'].toString();
            if (ts.compareTo(latestTs) > 0) {
              latestTs = ts;
              latestVal = value['valor'].toString();
            }
          }
        });

        setState(() {
          humedadActual = latestVal.isNotEmpty ? "$latestVal%" : "–";
        });
      }
    });
  }

  IconData obtenerIconoClima(String valor) {
    final temp = double.tryParse(valor) ?? 0;
    if (temp < 10) {
      return Icons.ac_unit;
    } else if (temp < 20) {
      return Icons.cloud;
    } else if (temp < 30) {
      return Icons.wb_sunny;
    } else {
      return Icons.wb_twilight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      color: Colors.indigoAccent,
      child: Row(
        children: [
          // Sección de la temperatura grande
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icono, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  tempActual,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),

          // Línea divisoria
          Container(width: 1, height: 80, color: Colors.white24),

          // Sección de resumen a la derecha
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Humedad: $humedadActual", style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Máxima: $tempMax", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  Text("Mínima: $tempMin", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
