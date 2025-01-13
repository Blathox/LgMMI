import 'package:loup_garou/game_logic/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/chat_screen.dart';
import 'phases.dart';
import 'package:flutter/material.dart';
class GameManager {
  List<Player> players = [];
  List<Player> alivePlayers = [];
  List<Player> deadPlayers = [];
  List<Player> loversPlayers = [];
  GamePhase gamePhase = GamePhase();

  final supabase = Supabase.instance.client;

  void startGame() {
    gamePhase.currentPhase = Phase.Day;
  }

  
  Future<List<Map<String, dynamic>>> fetchKilledPlayers() async {
  try {
 
    final response = await supabase
        .from('PLAYERS')
        .select('name, role')
        .eq('killedAtNight', true);

    if (response.isEmpty) {
      return [];
    }
    return List<Map<String, dynamic>>.from(response);
  } catch (error) {
    print("Erreur lors de la récupération des joueurs tués : $error");
    return [];
  }
}




  void processNightActions() {
    
  }

 
  void processDayActions() async {
  print("Le village se réveille...");

  List<Map<String, dynamic>> killedPlayers = await fetchKilledPlayers();

  if (killedPlayers.isEmpty) {
    print("Aucun joueur n'a été tué cette nuit.");
  } else {
    for (var player in killedPlayers) {
      print("${player['name']} a été tué cette nuit. Son rôle était : ${player['role']}");
      deadPlayers.add(Player(player['name'], player['role'], false));
    }
  }

void openChatScreen(BuildContext context, String gameId, String playerId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(gameId: gameId, playerId: playerId),
    ),
  );
}

  await Future.delayed(const Duration(minutes: 1, seconds: 30));
  print("Fin de la phase de discussion. Passage à la phase de vote.");

  // for (Player player in alivePlayers) {
  //   player.resetVote();
  // }
  // gamePhase.switchPhase();
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
