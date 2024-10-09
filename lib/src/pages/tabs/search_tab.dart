import 'package:flutter/material.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Pesquisar'),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      // ),
      body: const Center(
        child: Text(
          'Conteúdo da Aba Pesquisar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
