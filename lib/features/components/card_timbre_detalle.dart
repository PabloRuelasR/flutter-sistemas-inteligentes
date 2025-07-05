import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sistemas_inteligentes/features/components/dashboard_card.dart';
import 'package:audioplayers/audioplayers.dart';

class CardTimbreDetalle extends StatefulWidget {
  const CardTimbreDetalle({super.key});

  @override
  State<CardTimbreDetalle> createState() => _CardTimbreDetalleState();
}

class _CardTimbreDetalleState extends State<CardTimbreDetalle>
    with SingleTickerProviderStateMixin {
  final DatabaseReference ref = FirebaseDatabase.instance
      .ref('eventosTimbre/C56umbwmLOvvc2ePXH99');

  String valueText = "Sin registro";
  String lastRawDate = "";
  double iconScale = 1.0;
  final player = AudioPlayer();

  void _animateIcon() {
    setState(() {
      iconScale = 1.3;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        iconScale = 1.0;
      });
    });
  }

  void _triggerEffects() {
    //_playSound();
    _animateIcon();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final rawData = snapshot.data!.snapshot.value;

          if (rawData is Map<dynamic, dynamic>) {
            String latestTimestamp = "";

            rawData.forEach((key, value) {
              if (value is Map && value['timestamp'] != null) {
                final ts = value['timestamp'].toString();
                if (ts.compareTo(latestTimestamp) > 0) {
                  latestTimestamp = ts;
                }
              }
            });

            if (latestTimestamp.isNotEmpty && latestTimestamp != lastRawDate) {
              lastRawDate = latestTimestamp;
              try {
                final dateTime = DateTime.parse(latestTimestamp).toLocal();
                valueText = DateFormat('hh:mm a').format(dateTime);
              } catch (e) {
                valueText = "Formato inválido";
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _triggerEffects();
              });
            }
          }
        }

        return DashboardCard(
          title: "Timbre",
          iconWidget: AnimatedScale(
            scale: iconScale,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.notifications_active,
              size: 50,
              color: Colors.redAccent,
            ),
          ),
          value: valueText,
          color: Colors.redAccent,
        );
      },
    );
  }
}
