import 'package:flutter/material.dart';
import 'package:flutter_sistemas_inteligentes/features/components/card_timbre_detalle.dart';
import 'package:flutter_sistemas_inteligentes/features/view/home/home_page_widget.dart';
import 'package:flutter_sistemas_inteligentes/features/view/navigation/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedMenu = "Inicio";

  void onSelectMenu(String menu) {
    setState(() {
      selectedMenu = menu;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(selectedMenu: selectedMenu, onSelectMenu: onSelectMenu),
      appBar: AppBar(title: Text(selectedMenu)),
      body: Center(
        child: HomePageWidget(),
      )
    );
  }
}
