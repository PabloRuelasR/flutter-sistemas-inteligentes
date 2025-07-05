import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/view/reports/report_timbre_page.dart';
import 'package:flutter_sistemas_inteligentes/features/view/reports/report_humedad_page.dart';
import 'package:flutter_sistemas_inteligentes/features/view/reports/report_temperatura_page.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ReporteTimbrePage(),
    ReporteHumedadPage(),
    ReporteTemperaturaPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active), label: 'Timbre'),
          BottomNavigationBarItem(icon: Icon(Icons.water_drop_outlined), label: 'Humedad'),
          BottomNavigationBarItem(icon: Icon(Icons.thermostat_outlined), label: 'Temperatura'),
        ],
      ),
    );
  }
}
