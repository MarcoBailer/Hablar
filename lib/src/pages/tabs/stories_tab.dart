import 'package:flutter/material.dart';

class StoriesTab extends StatelessWidget {
  const StoriesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Histórias'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Conteúdo da Aba Histórias',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
