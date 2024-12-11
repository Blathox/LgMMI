import 'phases.dart';

class GameManager {
  GamePhase gamePhase = GamePhase();

  void startGame() {
    gamePhase.currentPhase = Phase.Day;
  }

  void processNightActions() {
    // Gérer les actions des rôles la nuit
  }

  void processDayActions() {
    // Gérer les votes ou discussions pendant le jour
  }
}
