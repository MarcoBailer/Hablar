import 'package:flutter/material.dart';
import 'package:hablar/src/pages/home/feature_screen.dart';
import 'package:provider/provider.dart';

import '../../Widgets/genre_tile.dart';
import '../../provider/user_model.dart';

class GenreSelectionScreen extends StatefulWidget {
  const GenreSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenreSelectionScreenState createState() => _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends State<GenreSelectionScreen> {
  // Lista completa de gêneros
  List<Genre> allGenres = [];
  // Lista filtrada para a pesquisa
  List<Genre> displayedGenres = [];
  // Lista de gêneros selecionados
  List<Genre> selectedGenres = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allGenres = _getGenres();
    displayedGenres = List.from(allGenres);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 16, 16),
      appBar: AppBar(
        title: const Text(
          'Escolha 3 ou mais gêneros de sua preferência',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 19, 16, 16),
      ),
      body: Column(
        children: [
          // Campo de pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterGenres,
            ),
          ),
          // Grelha de gêneros
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: displayedGenres.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 gêneros por linha
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.7, // Ajusta a proporção dos itens
              ),
              itemBuilder: (context, index) {
                final genre = displayedGenres[index];
                final isSelected = selectedGenres.contains(genre);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedGenres.remove(genre);
                      } else {
                        selectedGenres.add(genre);
                      }
                    });
                  },
                  child: GenreTile(
                    genre: genre,
                    isSelected: isSelected,
                  ),
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
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ElevatedButton(
                  onPressed: selectedGenres.length >= 3
                      ? () {
                          // Salva os gêneros selecionados usando o Provider
                          Provider.of<UserModel>(context, listen: false)
                              .setPreferredGenres(selectedGenres);

                          // Navega para a próxima tela
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeaturesScreen(),
                            ),
                          );
                        }
                      : null, // Desabilita o botão se menos de 3 gêneros forem selecionados
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

  // Função para filtrar os gêneros com base na pesquisa
  void _filterGenres(String query) {
    setState(() {
      displayedGenres = allGenres
          .where(
              (genre) => genre.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Função para obter a lista de gêneros
  List<Genre> _getGenres() {
    // Substitua pelos seus gêneros e imagens reais
    return [
      Genre(name: 'Ação', image: 'assets/images/Afterburner.png'),
      Genre(name: 'Comédia', image: 'assets/images/Time Bomb.png'),
      Genre(name: 'Drama', image: 'assets/images/Dance Gavin Dance.png'),
      Genre(name: 'Ficção Científica', image: 'assets/images/Tycho.png'),
      Genre(name: 'Terror', image: 'assets/images/From the Fires.png'),
      Genre(name: 'Romance', image: 'assets/images/Bryce Vine.png'),
      Genre(
          name: 'Suspense',
          image: 'assets/images/Anthem of the Peaceful Army.png'),
      // ... Adicione os outros gêneros aqui ...
    ];
  }
}
