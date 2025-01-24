/*import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/phases.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameHandler {
  final GameManager gameManager;
  final PlayersManager playersManager;
  ValueNotifier<String> gameMessage = ValueNotifier<String>("");
  ValueNotifier<GamePhase> currentPhase = ValueNotifier<GamePhase>(GamePhase());
  ValueNotifier<String> currentRole = ValueNotifier<String>("");

  GameHandler({required this.gameManager, required this.playersManager});

  void startGame(BuildContext context) {
    gameManager.startGame(context, 'game_id');
    currentPhase.value = gameManager.gamePhase;
    updateGameMessage("Le jeu a commencé !");
  }

  void updateGameMessage(String message) {
    gameMessage.value = message;
  }

  void switchPhase(BuildContext context) {
    gameManager.processGame(context, 'game_id');
    currentPhase.value = gameManager.gamePhase;
    currentRole.value = playersManager.player(); // Implémente cette méthode dans GameManager
    updateGameMessage("Phase: ${gameManager.gamePhase.currentPhase}");
  }

  void attribuerRoles() {
    gameManager.attribuerRoles();
    updateGameMessage("Les rôles ont été attribués !");
  }
}*/
