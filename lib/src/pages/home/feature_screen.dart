import 'package:flutter/material.dart';
import 'home_screen.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Título no topo da tela
      appBar: AppBar(
        title: const Text(
          'Hablar',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Torna o AppBar transparente
        elevation: 0, // Remove a sombra do AppBar
      ),
      extendBodyBehindAppBar: true, // Estende o corpo atrás do AppBar
      body: Stack(
        children: [
          // Imagem de background cobrindo toda a tela
          SizedBox.expand(
            child: Image.asset('assets/images/night-mood-night.jpg',
                fit: BoxFit.cover),
          ),
          // Conteúdo sobreposto à imagem
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Espaço para o título centralizado
              const Expanded(
                child: Center(
                  child: Text(
                    'Deixe nossa IA criar histórias incríveis para você!',
                    style: TextStyle(
                      color: Colors.white, // Cor do texto para contraste
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Botão "Continuar" no final da tela
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.orange],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navega para a tela HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
