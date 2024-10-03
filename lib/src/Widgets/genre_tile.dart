import 'package:flutter/material.dart';

class Genre {
  final String name;
  final String image;

  Genre({required this.name, required this.image});
}

class GenreTile extends StatelessWidget {
  final Genre genre;
  final bool isSelected;

  const GenreTile({Key? key, required this.genre, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Imagem do gênero
        Expanded(
          child: Stack(
            children: [
              // Imagem de fundo
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(genre.image),
                    fit: BoxFit.cover,
                    colorFilter: isSelected
                        ? ColorFilter.mode(
                            Colors.black.withOpacity(0.6), BlendMode.darken)
                        : null,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              // Ícone de seleção
              if (isSelected)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Nome do gênero
        Text(
          genre.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
