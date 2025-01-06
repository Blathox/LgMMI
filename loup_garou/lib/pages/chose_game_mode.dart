import 'package:flutter/material.dart';
import 'package:loup_garou/components/game_mode_card.dart';
import 'package:loup_garou/visuals/colors.dart';
class ChoseGameMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choisir le Mode de Jeu'),
        backgroundColor: yellow,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          children: [
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
