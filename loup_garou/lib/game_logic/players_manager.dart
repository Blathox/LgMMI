
import 'package:loup_garou/game_logic/player.dart';

class PlayersManager {
  List<Player> players = [];
  List<Player> alivePlayers = [];
  List<Player> loversPlayers = [];

  List<Player>

get playerList {
    return players;
  }
set playerList(List<Player> players) {
    this.players = players;
  }
  List<Player> getAlivePlayers() {
    return alivePlayers;
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

  Player? getPlayerTargeted() {
    for (Player player in alivePlayers) {
      if (player.isTargeted) {
        return player;
      }
      
  }
    return null;
}}