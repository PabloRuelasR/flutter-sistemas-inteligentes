import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/view/navigation/side_menu.dart';
import 'package:flutter_sistemas_inteligentes/features/view/home/home_page_widget.dart';
import 'package:flutter_sistemas_inteligentes/features/view/reports/report_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedMenu = "Inicio";

  final Map<String, Widget> screens = {
    "Inicio": HomePageWidget(),
    "Buscar": Center(child: Text("Pantalla de Buscar")),
    "Historial": Center(child: Text("Pantalla de Historial")),
    "Configuración": Center(child: Text("Pantalla de Configuración")),
    "Reportes": ReportesPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(
        selectedMenu: selectedMenu,
        onMenuChanged: (menu) {
          setState(() {
            selectedMenu = menu;
          });
        },
      ),
      appBar: AppBar(title: Text(selectedMenu)),
      body: screens[selectedMenu] ?? const Center(child: Text("Pantalla no disponible")),
    );
  }
}
