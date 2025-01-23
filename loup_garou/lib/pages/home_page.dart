import 'package:flutter/material.dart';
import 'package:loup_garou/pages/rules_page.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'chose_game_mode.dart';
import 'settings_page.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Boutons principaux
            SizedBox(
              width: 250,
              height: 45, 
              child: ElevatedButton(
                
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChoseGameMode()),
                  );
                },
                
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: yellow,
                ),
                child: const Text(
                  'Jouer',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: yellow,
                ),
                child: const Text(
                  'Mon profil',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RulesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                  ),
                  backgroundColor: yellow,
                ),
                child: const Text(
                  'Règles & Rôles',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Ligne des icônes dans un conteneur de largeur fixe
            SizedBox(
  width: 250, // Même largeur que les boutons principaux
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Bouton "Joueurs"
      Expanded(
        child: SizedBox(
          height: 45, // Définir la hauteur ici
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Icon(Icons.group, color: Colors.white, size: 22.5),
          ),
        ),
      ),
      const SizedBox(width: 10), // Espacement fixe entre les deux icônes
      // Bouton "Paramètres"
      Expanded(
        child: SizedBox(
          height: 45, // Définir la hauteur ici
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 22.5),
          ),
        ),
      ),
    ],
  ),
)

          ],
        ),
      ),
    );
  }
}
