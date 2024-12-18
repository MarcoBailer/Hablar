import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hablar/src/pages/auth/login_screen.dart';
import 'package:hablar/src/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  // Instance of FlutterSecureStorage to handle logout
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.white),
            title: const Text('Conta', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Nome de usuário ° Cobrança',
                style: TextStyle(color: Colors.white70)),
            onTap: () {
              // Navegar para a tela de configurações de conta
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note, color: Colors.white),
            title: const Text('Conteúdo e tela',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Idioma do app',
                style: TextStyle(color: Colors.white70)),
            onTap: () {
              // Navegar para a tela de configurações de conteúdo e tela
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.white),
            title: const Text('Privacidade',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text(
                'Artistas tocados recentemente ° Quem te segue e contas que você segue',
                style: TextStyle(color: Colors.white70)),
            onTap: () {
              // Navegar para a tela de configurações de privacidade
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.white),
            title: const Text('Notificações',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Push ° E-mail',
                style: TextStyle(color: Colors.white70)),
            onTap: () {
              // Navegar para a tela de configurações de notificações
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text('Sobre', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Versão ° Política de privacidade',
                style: TextStyle(color: Colors.white70)),
            onTap: () {
              // Navegar para a tela "Sobre"
            },
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: ElevatedButton(
              onPressed: () async {
                // Limpa os dados de autenticação armazenados
                await _authService.logout();
                // Navega de volta para a tela de login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Cor de fundo branca
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Borda arredondada
                ),
              ),
              child: const Text(
                'Sair',
                style: TextStyle(color: Colors.black), // Texto preto
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
