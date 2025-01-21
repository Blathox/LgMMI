import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/player.dart';

class TestLogicScreen extends StatelessWidget {
  final GameManager gameManager;

  const TestLogicScreen({super.key, required this.gameManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Logique Nuit/Jour'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Tester la phase de nuit
                await gameManager.processNightActions(context);
                print("Phase de nuit terminée !");
              },
              child: const Text("Tester Phase de Nuit"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Tester la phase de jour
                await gameManager.processDayActions(context, '119c6a81-116a-4859-b73c-1c443a8a54f8');
                print("Phase de jour terminée !");
              },
              child: const Text("Tester Phase de Jour"),
            ),
          ],
        ),
      ),
    );
  }
}
