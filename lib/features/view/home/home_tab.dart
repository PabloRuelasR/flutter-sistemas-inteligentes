import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/components/card_timbre_detalle.dart';
import 'package:flutter_sistemas_inteligentes/features/components/card_humedad.dart';
import 'package:flutter_sistemas_inteligentes/features/components/card_temperatura.dart';
import 'package:flutter_sistemas_inteligentes/features/components/card_foco.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Dashboard", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              CardTimbreDetalle(),
              CardHumedad(),
              CardTemperatura(),
              CardFoco(),
            ],
          ),
        ],
      ),
    );
  }
}
