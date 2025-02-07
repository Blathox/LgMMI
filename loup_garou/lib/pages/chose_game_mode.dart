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
            // Mode de jeu n°2 : Partie Classique
            GameModeCard(
              title: 'Partie privée',
              icon: Icons.settings,
              image1: '../../assets/images/createPartyIMG.svg',
              image2: '../../assets/images/joinPartieIMG.svg',
              titleImg1: 'Rejoindre une partie privée',
              titleImg2: 'Créer une partie privée',
              redirectionImage1: false,
              redirectionImage2: true,
              
            ),
          ],
        ),
      ),
    );
  }
}
