import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Widget? iconWidget;
  final String? value;
  final Color color;
  final Widget? child;

  const DashboardCard({
    super.key,
    this.title,
    this.icon,
    this.iconWidget,
    this.value,
    required this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      // ✅ Usar contenido personalizado
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child!,
        ),
      );
    }

    // ✅ Diseño clásico
    final Widget iconToShow = iconWidget ??
        Icon(
          icon,
          size: 40,
          color: color,
        );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconToShow,
            const SizedBox(height: 12),
            Text(
              title ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
