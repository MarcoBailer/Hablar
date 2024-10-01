import 'package:flutter/material.dart';
// Importe a HomePage ou a próxima tela
import 'home_page.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FeatureItem> features = [
      FeatureItem(
        icon: Icons.chat,
        title: 'Teens',
      ),
      FeatureItem(
        icon: Icons.group,
        title: 'Velho oeste',
      ),
      FeatureItem(
        icon: Icons.photo,
        title: 'Inspirados em histórias de games',
      ),
      FeatureItem(
        icon: Icons.call,
        title: 'inspirados em personagens de filmes e series',
      ),
      FeatureItem(
        icon: Icons.videocam,
        title: 'inspirados em personagens de quadrinhos',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 16, 16),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Crie seus próprios roteiros',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Lista de recursos
          Expanded(
            child: ListView.builder(
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FeatureTile(feature: feature),
                );
              },
            ),
          ),
          // Botão "Continuar"
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
                    // Navega para a próxima tela
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
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
    );
  }
}

class FeatureItem {
  final IconData icon;
  final String title;

  FeatureItem({required this.icon, required this.title});
}

class FeatureTile extends StatelessWidget {
  final FeatureItem feature;

  const FeatureTile({Key? key, required this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Ícone à esquerda
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            feature.icon,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        // Título à direita
        Expanded(
          child: Text(
            feature.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
