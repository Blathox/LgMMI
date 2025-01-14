import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameModeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String image1;
  final String? image2; // Image facultative
  final String titleImg1;
  final String? titleImg2;

  const GameModeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.image1,
    this.image2,
    required this.titleImg1,
    this.titleImg2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: yellow,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  icon,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                GestureDetector(
                  // onTap: () => _handleTap(context, image2!, titleImg2 ?? ""),
                  onTap: () => _showGameCodeDialog(context),
                  child:
                      // Premier Container avec titre superposé
                      Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(
                          image1,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        titleImg1, // Utilisation du paramètre `titleImg1`
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black54,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (image2 != null) const SizedBox(height: 10),
                // Deuxième Container avec titre superposé (si présent)
                if (image2 != null)
                  GestureDetector(
                    // onTap: () => _handleTap(context, image2!, titleImg2 ?? ""),
                    onTap: () {
                      Navigator.pushNamed(context, '/settingsGame');
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            image2!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          titleImg2 ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black54,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

//   void _handleTap(BuildContext context, String image, String title) {
//     if (redirection) {
//       // Redirection vers une autre page
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailPage(
//             title: title,
//             image: image,
//           ),
//         ),
//       );
//     } else {
//       // Ouvrir une pop-up
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(title),
//           content: SvgPicture.asset(image),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Fermer"),
//             ),
//           ],
//         ),
//       );
//     }
//   }

// }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(), // Convertir tout en majuscules
      selection: newValue.selection,
    );
  }
}
void _showGameCodeDialog(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Entrer le code de la partie"),
          content: TextField(
            controller: codeController,
            inputFormatters: [
            UpperCaseTextFormatter(), // Forcer les majuscules
            ],
            decoration: const InputDecoration(
              labelText: "Code de la partie",
              hintText: "Ex: ABC123",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                final gameCode = codeController.text.trim();

                if (gameCode.isNotEmpty) {
                  Navigator.of(context).pop(); // Fermer le dialogue
      
                  // Rediriger vers la page correspondante avec le code de la partie
                  Navigator.pushNamed(
                    context,
                    '/gameScreen',
                    arguments: {'gameCode': gameCode},
                  );
                } else {
                  // Afficher un message d'erreur si le code est vide
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Veuillez entrer un code valide."),
                    ),
                  );
                }
              },
              child: const Text("Rejoindre"),
            ),
          ],
        );
      },
    );
  }
