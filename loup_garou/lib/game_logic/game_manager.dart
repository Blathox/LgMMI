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


  Future<int> fetchVoteDuration(String gameId) async {
    try {
      final response = await supabase
          .from('GAMES')
          .select('settings->>voteDuration')
          .eq('id', gameId)
          .single();

      if (response.isEmpty) {
        print("Erreur : Durée de vote introuvable, valeur par défaut utilisée.");
        return 90;
      }

      return int.tryParse(response['settings->>voteDuration']) ?? 90;
    } catch (error) {
      print("Erreur lors de la récupération de la durée de vote : $error");
      return 90;
    }
  }

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
  
    // Phase de discussion avec le chat
    // openChatScreen(context, gameId);

    // Récupérer la durée de vote
    int voteDuration = await fetchVoteDuration(gameId);
    print("Durée de la phase de vote : $voteDuration secondes.");

    // Attendre la fin de la durée configurée
    await Future.delayed(Duration(seconds :voteDuration));
    print("Fin de la phase de vote.");

    // Passer à la phase suivante
    gamePhase.switchPhase();
  }

  // void openChatScreen(BuildContext context, String gameId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ChatScreen(gameId: gameId, playerId: playersM.playerList[0].id), // Exemple
  //     ),
  //   );
  // }

 

 
}
