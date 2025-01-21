import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import '../screens/chat_screen.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'phases.dart';
import 'package:collection/collection.dart';


class GameManager {
  GamePhase gamePhase = GamePhase();
  List<RoleAction> roles = [];
  List<RoleAction> rolesAttribued = [];
  List<Player> alivePlayers = [];
  List<Player> deadPlayers = [];
  List<Player> loversPlayers = [];
  bool isRunning = false;
  bool isWin = false;
  ValueNotifier<String> messageNotifier = ValueNotifier<String>("");

  PlayersManager playersM = PlayersManager();

  final supabase = Supabase.instance.client;

  GameManager(this.roles) {
    
    roles = roles;
    rolesAttribued = [];
  }
  get getRoles => roles;
  get getRolesAttribued => rolesAttribued;
  set setRoles(List<RoleAction> roles) {
    this.roles = roles;
  }
  set playersManager(PlayersManager playersManager) {
    playersM = playersManager;
  }

  // Getter pour accéder au message
  String get getMessage => messageNotifier.value;

  // Méthode pour mettre à jour le message
  void updateMessage(String newMessage) {
    messageNotifier.value = newMessage; // Notifie automatiquement les listeners
  }
    void startGame(BuildContext context, String gameId) async {
      isRunning = true;
      print(isRunning);
    // gamePhase.currentPhase = Phase.Night;

    // await processNightActions(context);
    // await processDayActions(context, gameId);
  }
  void processGame(BuildContext context) async {
      gamePhase.switchPhase();
      print("Phase actuelle : ${gamePhase.currentPhase}");
      // if(gamePhase.currentPhase == Phase.Night){
        await processNightActions(context);
    //   }else if(gamePhase.currentPhase == Phase.Day){
    //     // await processDayActions(context, 'gameId');
      
    // }

  }

  /// Récupère les joueurs tués pendant la nuit
  Future<List<Map<String, dynamic>>> fetchKilledPlayers() async {
  try {
    final response = await supabase
        .from('PLAYERS')
        .select('id, killedatnight, role, USERS(username)')
        .eq('killedatnight', true);

    if (response.isEmpty) {
      print("Aucune donnée récupérée ou le champ killedatnight = true est introuvable.");
      return [];
    }

    return List<Map<String, dynamic>>.from(response);
  } catch (error) {
    print("Erreur lors de la récupération des joueurs tués : $error");
    return [];
  }
}


//   Future<int> fetchVoteDuration(String gameId) async {
//   try {
//     final response = await supabase
//         .from('GAMES')
//         .select('settings')
//         .eq('id', gameId)
//         .single();

//     if (response.isEmpty) {
//       print("Erreur : Durée de vote introuvable, valeur par défaut utilisée.");
//       return 10; // Valeur par défaut
//     }

//     // Extraire la valeur de voteDuration depuis le champ JSON settings
//     final settings = response['settings'] as Map<String, dynamic>;
//     return settings['voteDuration'] ?? 90; // Retourner la valeur ou une valeur par défaut
//   } catch (error) {
//     print("Erreur lors de la récupération de la durée de vote : $error");
//     return 90; // Valeur par défaut en cas d'erreur
//   }
// }
Future<int> fetchVoteDuration(String gameId) async {
  try {
    // Ignorer la récupération réelle pour fixer le temps de vote à 10s
    print("Durée de vote temporairement fixée à 10 secondes.");
    return 1; // Durée temporaire de 10 secondes
  } catch (error) {
    print("Erreur lors de la récupération de la durée de vote : $error");
    return 1; // Valeur par défaut en cas d'erreur
  }
}



  /// Traite les actions de nuit
  Future<void> processNightActions(BuildContext context) async {
    updateMessage("Le village s'endort");
    print('test $rolesAttribued');
    for (RoleAction role in rolesAttribued) {
      print("Action du rôle : ${role.getName}");
      role.performAction(context, playersM);
    }
    print("Fin de la phase de nuit.");
  }
void attribuerRoles(){
    updateMessage("Attribution des rôles");
    print('attribution roles $roles');
    print(playersM.playerList.length);
    print(playersM.playerList);
    roles.shuffle();
    for (int i = 0; i < playersM.playerList.length; i++) {
      playersM.playerList[i].setRole(roles[i]);
      print('roles ${roles[i].getName}');
      rolesAttribued.add(roles[i]);
      roles.remove(roles[i]);
    }
    rolesAttribued.sort((a, b) => a.order.compareTo(b.order));
   updateMessage("Les rôles ont été attribués");
  }
  Future<void> processDayActions(BuildContext context, String gameId) async {
    print("Le village se réveille...");

    // Annonce des joueurs tués
    List<Map<String, dynamic>> killedPlayers = await fetchKilledPlayers();
    if (killedPlayers.isEmpty) {
      print("Aucun joueur n'a été tué cette nuit.");
    } else {
      for (var player in killedPlayers) {
        print("${player['USERS']['username']} a été tué cette nuit. Son rôle était : ${player['role']}");

        deadPlayers.add(Player(
          player['USERS']['username'],
          false,
        )..playerId = player['id']);

        alivePlayers.removeWhere((p) => p.playerId == player['id']);
      }
    }

    // Préparer la phase de vote
    await prepareVoting(gameId);

    // Collecter les votes
    await collectVotes(gameId);

    // Passer à la phase suivante
    gamePhase.switchPhase();
  }

  /// Prépare la phase de vote
Future<void> prepareVoting(String gameId) async {
  print("Préparation de la phase de vote...");
  try {
    await supabase.from('VOTES').delete().eq('game_id', gameId);
    print("Tous les votes précédents ont été supprimés.");
  } catch (error) {
    print("Erreur lors de la préparation des votes : $error");
  }
}

/// Collecte les votes et gère les résultats
Future<void> collectVotes(String gameId) async {
  print("Phase de vote en cours...");

  // Attendre la durée de la phase de vote
  int voteDuration = await fetchVoteDuration(gameId);
  print("Les joueurs ont $voteDuration secondes pour voter.");
  await Future.delayed(Duration(seconds: voteDuration));

  try {
    // Récupérer les votes enregistrés
    final response = await supabase.rpc('group_votes', params: {'game_id_input': gameId});
print("Réponse brute de la procédure RPC : $response");
    if (response == null || response.isEmpty) {
      print("Aucun vote enregistré ou erreur lors de la récupération des votes.");
      return;
    }

    print("Votes récupérés : $response");

    // Calculer les votes
    Map<String, int> voteCounts = {};
    for (var vote in response) {
      String targetId = vote['target_id'];
      int voteCount = vote['vote_count'];
      voteCounts[targetId] = voteCount;
    }

Future<void> refreshAlivePlayers() async {
  final response = await supabase
      .from('PLAYERS')
      .select()
      .eq('status', true); // Récupère uniquement les joueurs vivants

  alivePlayers = (response as List).map((data) => Player.fromMap(data)).toList();

  print("Liste mise à jour des joueurs vivants :");
  for (var player in alivePlayers) {
    print("ID : ${player.playerId}, Nom : ${player.name}");
  }
}

await refreshAlivePlayers();

    // Identifier le joueur éliminé
String? eliminatedPlayerId;
if (voteCounts.isNotEmpty) {
  eliminatedPlayerId = voteCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
}

if (eliminatedPlayerId != null) {
  print("test $eliminatedPlayerId");

  // Mettre à jour le statut du joueur dans la base de données
  final updateResponse = await supabase
    .from('PLAYERS')
    .update({"status": false})
    .eq('id', eliminatedPlayerId)
    .select();

print("Mise à jour dans la base de données : $updateResponse");

// Rafraîchir la liste des joueurs vivants
await refreshAlivePlayers();

  print("test22222 $updateResponse");

  // Vérifie si la mise à jour a fonctionné
  if (updateResponse.isEmpty) {
    print("Échec de la mise à jour du statut pour l'ID : $eliminatedPlayerId");
    return;
  } else {
    print("Le joueur avec l'ID $eliminatedPlayerId a été marqué comme éliminé.");
  }

  // Vérifie la liste des joueurs vivants
  print("Liste des joueurs vivants (alivePlayers) :");
  for (var player in alivePlayers) {
    print("ID joueur vivant : ${player.playerId}");
  }

  // Trouve le joueur éliminé dans la liste locale
  Player? eliminatedPlayer = alivePlayers.firstWhereOrNull(
  (p) => p.playerId.trim() == eliminatedPlayerId!.trim(),
  );
 
  print("Liste des joueurs vivants (alivePlayers) après mise à jour :");
for (var player in alivePlayers) {
  print("le player $player");
  print("ID joueur vivant : ${player.playerId}, Nom : ${player.getName()}");
}


  if (eliminatedPlayer != null) {
    eliminatedPlayer.killed();
    alivePlayers.remove(eliminatedPlayer);
    deadPlayers.add(eliminatedPlayer);

    print("${eliminatedPlayer.getName()} a été éliminé. Son rôle était : ${eliminatedPlayer.role.name}");
  } else {
    print("Aucun joueur correspondant trouvé pour l'ID : $eliminatedPlayerId dans la liste des vivants.");
  }
} else {
  print("Aucun joueur n'a été éliminé (aucun vote majoritaire).");
}
  } catch (error) {
    print("Erreur lors de la récupération des votes : $error");
  }

}
}