import 'package:flutter/material.dart';
import 'package:loup_garou/components/game_mode_card.dart';
import 'package:loup_garou/visuals/colors.dart';
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
          children: const [
            // Mode de jeu n°1 : Partie Rapide
            GameModeCard(
              title: 'Partie Rapide',
              icon: Icons.settings,
              

            ),
          ],
        ),
      ),
    );
  }
}
