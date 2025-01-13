import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';

import 'phases.dart';

class GameManager {
 
  GamePhase gamePhase = GamePhase();
  GameSettingsManager gameSettings = GameSettingsManager(6);
  List<RoleAction> roles=[];
  List<RoleAction> rolesAttribued = [];
  bool isWin = false;
    PlayersManager playersM = PlayersManager();

  GameManager(this.gameSettings) {
    roles = gameSettings.roles;
    rolesAttribued = [];
  }


  void startGame(BuildContext context) {
    // Initialiser les roles
    // Distribuer les rôles aux joueurs
    print("Attribution des rôles");
    roles.shuffle();
    for (int i = 0; i < playersM.getPlayers().length; i++) {

      playersM.getPlayers()[i].setRole(roles[i]);
      rolesAttribued.add(roles[i]);
      roles.remove(roles[i]);
    }
      rolesAttribued.sort((a, b) => a.order.compareTo(b.order));

    // Définir le premier tour de jeu
        gamePhase.currentPhase = Phase.Night;

    while(!isWin){
      processNightActions( context);
      processDayActions();

    }

  }


  void processNightActions(BuildContext context) {
    // Gérer les actions des rôles la nuit
    for( RoleAction role in rolesAttribued){
        role.performAction(context, playersM);

      
    }
    

  }

  void processDayActions() {
    // Gérer les votes ou discussions pendant le jour
  }
  }
