import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import '../screens/chat_screen.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'phases.dart';

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
          .select('id, name, role')
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



  /// Récupère la durée de la phase de vote
  Future<int> fetchVoteDuration(String gameId) async {
    try {
      final response = await supabase
          .from('GAMES')
          .select('settings->>voteDuration')
          .eq('id', gameId)
          .single();

      if (response.isEmpty) {
        print(
            "Erreur : Durée de vote introuvable, valeur par défaut utilisée.");
        return 90;
      }

      return int.tryParse(response['settings->>voteDuration']) ?? 90;
    } catch (error) {
      print("Erreur lors de la récupération de la durée de vote : $error");
      return 90;
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
        print(
            "${player['name']} a été tué cette nuit. Son rôle était : ${player['role']}");

        deadPlayers.add(Player(
          player['name'],
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
    await supabase.from('VOTES').delete().eq('game_id', gameId);
    print("Tous les votes précédents ont été supprimés.");
  }

  /// Collecte les votes et gère les résultats
  Future<void> collectVotes(String gameId) async {
    print("Phase de vote en cours...");

    // Attendre la durée de la phase de vote
    int voteDuration = await fetchVoteDuration(gameId);
    print("Les joueurs ont $voteDuration secondes pour voter.");
    await Future.delayed(Duration(seconds: voteDuration));

    // Récupérer les votes enregistrés
    final response =
        await supabase.rpc('group_votes', params: {'game_id_input': gameId});

    if (response.data == null || response.data.isEmpty) {
      print(
          "Aucun vote enregistré ou erreur lors de la récupération des votes.");
      return;
    }

    // Calculer les votes
    Map<String, int> voteCounts = {};
    for (var vote in response.data) {
      String targetId = vote['target_id'];
      int voteCount = vote['vote_count'];
      voteCounts[targetId] = voteCount;
    }

    // Identifier le joueur éliminé
    String eliminatedPlayerId =
        voteCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    Player eliminatedPlayer = alivePlayers.firstWhere(
      (p) => p.playerId == eliminatedPlayerId,
      orElse: () {
        // Crée un joueur fictif si aucun joueur n'est trouvé
        print(
            "Aucun joueur correspondant trouvé pour l'ID : $eliminatedPlayerId");
        return Player("Inconnu", false); // Fournir un joueur par défaut
      },
    );

// Procéder à l'élimination si le joueur trouvé est valide
    if (eliminatedPlayer.name != "Inconnu") {
      eliminatedPlayer.killed();
      alivePlayers.remove(eliminatedPlayer);
      deadPlayers.add(eliminatedPlayer);

      print(
          "${eliminatedPlayer.name} a été éliminé. Son rôle était : ${eliminatedPlayer.role.name}");
    } else {
      print("Aucune élimination n'a été effectuée.");
    }
  }

  /// Ajoute un joueur
  void addPlayer(Player player) {
    players.add(player);
  }

  /// Supprime un joueur
  void removePlayer(Player player) {
    players.remove(player);
  }

  /// Récupère un joueur par son nom
  Player? getPlayerByName(String name) {
    return players.firstWhere((player) => player.name == name,
        orElse: () => Player("Inconnu", false));
  }

  /// Ajoute une liaison entre deux joueurs
  void addPlayerLinked(Player player1, Player player2) {
    player1.isLinked = true;
    player2.isLinked = true;
    loversPlayers.add(player1);
    loversPlayers.add(player2);
  }
}
