import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? iconWidget;
  final String value;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    this.icon,
    this.iconWidget,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
