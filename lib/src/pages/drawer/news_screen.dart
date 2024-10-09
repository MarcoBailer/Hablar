import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilize o AppBar personalizado, se desejar
      appBar: AppBar(
        title: const Text('Novidades'),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text('Tela de Novidades', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.black,
    );
  }
}
