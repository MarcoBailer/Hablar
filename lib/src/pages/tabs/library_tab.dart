import 'package:flutter/material.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Biblioteca'),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      // ),
      body: const Center(
        child: Text(
          'Conteúdo da Aba Biblioteca',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
