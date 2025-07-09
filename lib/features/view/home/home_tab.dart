import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sistemas_inteligentes/features/components/card_clima.dart';
import 'package:flutter_sistemas_inteligentes/features/components/card_timbre_detalle.dart';
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
          const Text(
            "Dashboard",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: const [
              StaggeredGridTile.fit(
                crossAxisCellCount: 1,
                child: CardTimbreDetalle(),
              ),
              StaggeredGridTile.fit(
                crossAxisCellCount: 1,
                child: CardFoco(),
              ),
              StaggeredGridTile.fit(
                crossAxisCellCount: 2, // 👈 ¡ocupa 2 columnas!
                child: CardClimaResumen(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
