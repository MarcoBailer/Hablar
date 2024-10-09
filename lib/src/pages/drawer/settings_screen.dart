import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilize o AppBar personalizado, se desejar
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Tela de Configurações',
            style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
    );
  }
}
