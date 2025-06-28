import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'analytics_tab.dart';
import 'devices_tab.dart';
import 'settings_tab.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    AnalyticsTab(),
    DevicesTab(),
    SettingsTab(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Analíticas'),
          BottomNavigationBarItem(icon: Icon(Icons.light_outlined), label: 'Dispositivos'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Configuración'),
        ],
      ),
    );
  }
}
