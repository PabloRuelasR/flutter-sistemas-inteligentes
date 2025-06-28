import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity, // Asegura que ocupe todo el ancho
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CircleAvatar(
            radius: 30,
            child: Icon(Icons.person, size: 30),
          ),
          SizedBox(height: 10),
          Text(
            "Casa Domótica",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "Sistemas Inteligentes",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
