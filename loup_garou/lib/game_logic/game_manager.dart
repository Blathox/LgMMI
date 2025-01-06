import 'package:loup_garou/game_logic/player.dart';

import 'phases.dart';

class GameManager {
  List<Player> players = [];
  List<Player> alivePlayers = [];
  List<Player> deadPlayers = [];
  List<Player> loversPlayers = [];
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
  void addPlayer(Player player) {
    players.add(player);
  }
  void removePlayer(Player player) {
    players.remove(player);
  }
  Player? getPlayerByName(String name) {
    for (Player player in players) {
      if (player.name == name) {
        return player;
      }
    }
    return null;
  }
  void addPlayerLinked(Player player1, Player player2) {
    player1.isLinked = true;
    player2.isLinked = true;
    loversPlayers.add(player1);
    loversPlayers.add(player2);
  }
}
