import 'package:flutter/material.dart';
import 'package:hablar/src/Widgets/custom_app_bar.dart';
import 'package:hablar/src/Widgets/custom_drawer.dart';

import '../tabs/home_tab.dart';
import '../tabs/library_tab.dart';
import '../tabs/search_tab.dart';
import '../tabs/stories_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de widgets para cada aba
  final List<Widget> _screens = [
    const HomeTab(),
    const SearchTab(),
    const StoriesTab(),
    const LibraryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: _screens[
          _currentIndex], // Exibe a tela correspondente à aba selecionada
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza o índice atual
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _currentIndex == 0 ? Colors.white : Colors.grey),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: _currentIndex == 1 ? Colors.white : Colors.grey),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book,
                color: _currentIndex == 2 ? Colors.white : Colors.grey),
            label: 'Histórias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music,
                color: _currentIndex == 3 ? Colors.white : Colors.grey),
            label: 'Biblioteca',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}
