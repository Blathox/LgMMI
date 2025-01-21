import 'package:flutter/material.dart';
import 'package:loup_garou/components/game_mode_card.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'package:loup_garou/screens/test_logic_screen.dart'; // Import de la page de test
import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';

class ChoseGameMode extends StatelessWidget {
  const ChoseGameMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir le Mode de Jeu'),
        backgroundColor: yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // Mode de jeu n°2 : Partie Classique
            const GameModeCard(
              title: 'Partie privée',
              icon: Icons.settings,
              image1: '../../assets/images/createPartyIMG.svg',
              image2: '../../assets/images/joinPartieIMG.svg',
              titleImg1: 'Rejoindre une partie privée',
              titleImg2: 'Créer une partie privée',
              redirectionImage1: false,
              redirectionImage2: true,
            ),
            const SizedBox(height: 20), // Espacement entre les éléments
            // Bouton pour accéder à la page de test
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestLogicScreen(
                      gameManager: GameManager([]), // Passe une liste vide pour les rôles
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Tester Phase Nuit/Jour",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
