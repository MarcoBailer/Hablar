import 'package:flutter/material.dart';

import '../pages/drawer/news_screen.dart';
import '../pages/drawer/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              accountName: const Text(
                'Nome do Usuário',
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: const Text(
                'email@exemplo.com',
                style: TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {},
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/Tycho.png'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Configurações',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SettingsScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.new_releases, color: Colors.white),
              title: const Text('Novidades',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const NewsScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
