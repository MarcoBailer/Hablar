import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Início'),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      // ),
      body: Center(
        child: Text(
          'Conteúdo da Aba Início',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
