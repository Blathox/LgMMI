import 'package:flutter/material.dart';

class ChoseGameMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisir le Mode de Jeu'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              'Modes de jeu disponibles',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Espacement entre le titre et le premier bloc

            // Premier SizedBox
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titre à gauche
                  Text(
                    'Mode A',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Icône à droite
                  Icon(Icons.gamepad, size: 30),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Image en dessous
            Image.asset('assets/image1.jpg'), // Remplacer par le chemin de votre image

            const SizedBox(height: 20), // Espacement entre les blocs

            // Deuxième SizedBox
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titre à gauche
                  Text(
                    'Mode B',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Icône à droite
                  Icon(Icons.sports_esports, size: 30),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Image en dessous
            Image.asset('assets/image2.jpg'), // Remplacer par le chemin de votre image

            const SizedBox(height: 20), // Espacement entre les blocs

            // Troisième SizedBox
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titre à gauche
                  Text(
                    'Mode C',
                    style: TextStyle(fontSize: 18),
                  ),
                  // Icône à droite
                  Icon(Icons.videogame_asset, size: 30),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Deux images à la suite dans une Row
            Row(
              children: [
                Image.asset('assets/image3.jpg', width: 100, height: 100), // Remplacer par le chemin de votre image
                const SizedBox(width: 10), // Espacement entre les images
                Image.asset('assets/image4.jpg', width: 100, height: 100), // Remplacer par le chemin de votre image
              ],
            ),
          ],
        ),
      ),
    );
  }
}
