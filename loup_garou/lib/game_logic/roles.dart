import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:loup_garou/game_logic/players_manager.dart';

abstract class RoleAction {
  final String name;
  final int order;
  final String description;
  RoleAction({required this.name, required this.description, required this.order});


  void performAction(BuildContext context, PlayersManager PlayersManager);
}

////////////////////////////////////////////////////////////////

class LoupGarou extends RoleAction {

  List<String> availableTargets = []; 
  String? chosenTarget; 

  LoupGarou({required super.name, required super.description, required super.order});

  @override
  void performAction(BuildContext context, PlayersManager gameManager) {
    if (availableTargets.isEmpty) {
      print("Aucune cible disponible pour les Loups-Garous.");
      return;
    }

    if (chosenTarget == null) {
      print("Le Loup-Garou doit choisir une cible.");
      return;
    }

    print("Le Loup-Garou attaque $chosenTarget !");
    eliminateTarget(chosenTarget!);
  }

  void setAvailableTargets(List<String> players) {
    availableTargets = players;
    print("Cibles disponibles pour les Loup-Garous : ${availableTargets.join(', ')}");
  }

  void selectTarget(String targetName) {
    if (!availableTargets.contains(targetName)) {
      print("$targetName n'est pas une cible valide.");
      return;
    }
    chosenTarget = targetName;
    print("Le Loup-Garou a choisi d'attaquer : $targetName");
  }

  void eliminateTarget(String targetName) {
    print("$targetName a été éliminé par les Loups-Garous.");
    // logique pour mettre à jour l'état du joueur dans le jeu.
  }
}



////////////////////////////////////////////////////////////////

class Villageois extends RoleAction {
  Villageois({required super.name, required super.description, required super.order});

  @override
  void performAction(BuildContext context, PlayersManager gameManager) {
    print("Le Villageois participe aux votes pour éliminer un joueur.");
  }
}
class Sorciere extends Villageois {
  Sorciere({required super.name, required super.description, required super.order});

  @override
  void performAction(BuildContext context, PlayersManager gameManager) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Action de la Sorcière"),
          content: Text("Le joueur ${gameManager.getPlayerTargeted()} a été tué. Voulez-vous le sauver, tuer quelqu'un d'autre ou ne rien faire ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if(gameManager.getPlayerTargeted() == null){
                  print("Aucun joueur n'a été tué.");
                  return;
                }else{
                    Player? targetedPlayer = gameManager.getPlayerTargeted();
                    if (targetedPlayer != null) {
                      savePlayer(targetedPlayer, gameManager);
                    } else {
                      print("Aucun joueur n'a été tué.");
                    }
                }
                Navigator.of(context).pop();
              },
              child: const Text("Sauver"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Tuer un autre joueur"),
                      content: ListView(
                        children:gameManager.getPlayers().map((player) {
                          return ListTile(
                            
                            title: Text(player.getName()),
                            onTap: () {
                              killPlayer(player.getName(), gameManager);
                              Navigator.of(context).pop();
                            },
                          );
                        }).toList(),
                       
                      ),
                    );
                  },
                );
              },
              child: const Text("Tuer"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print("La Sorcière n'a rien fait.");
              },
              child: const Text("Ne rien faire"),
            ),
          ],
        );
      },
    );
  }

  void savePlayer(Player player, PlayersManager gameManager) {
      player.revive();
      print("La Sorcière a sauvé ${player.getName()}.");
    
  }

  void killPlayer(Player player, PlayersManager gameManager) {

      player.killed();
      print("La Sorcière a éliminé ${player.getName()}.");
    
  }
}
class Chasseur extends Villageois {
  Chasseur({required super.name, required super.description, required super.order});

  @override
  void performAction(
    BuildContext context, PlayersManager gameManager) {
    print("Le Chasseur peut éliminer un joueur avant de mourir.");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Chasseur"),
          content: ListView(
            children: gameManager.getPlayers().map((player) {
              return ListTile(
                title: Text(player.name),
                onTap: () {
                  killPlayer(player.name, gameManager);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
  

    void killPlayer(String playerName,PlayersManager gameManager) {

    Player? player = gameManager.getPlayerByName(playerName);
    if (player == null) {
      print("Le joueur $playerName n'existe pas.");
      return;
    }
    else{
          player.killed();
         print("Le chasseur a éliminé $playerName.");
 }
  }
}
class Cupidon extends Villageois {
  Cupidon({required super.name, required super.description, required super.order});

  @override
  void performAction(BuildContext context, PlayersManager gameManager) {
    print("Vous êtes cupidon et votre mission est de relier deux personnes par les liens de l'amour. Qui choisissez vous ?");
    List<String> playersSelected = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cupidon"),
          content: ListView(
            children: gameManager.getPlayers().map((player) {
              return ListTile(
                title: Text(player.name),
                onTap: () {
                  playersSelected.add(player.name);
                  if (playersSelected.length == 2) {
                    linkPlayers(playersSelected[0], playersSelected[1], gameManager);
                    Navigator.of(context).pop();
                  }
                  
              
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
  void linkPlayers(String player1, String player2, PlayersManager gameManager) {
  Player? p1 = gameManager.getPlayerByName(player1);
  Player? p2 = gameManager.getPlayerByName(player2);
  if (p1 == null || p2 == null) {
    print("Les joueurs $player1 et $player2 doivent être présents dans la partie.");
    return;
  } else {
    gameManager.addPlayerLinked(p1, p2);
    print("Vous avez lié $player1 et $player2.");
  }
}}
class Voyante extends Villageois {
  Voyante({required super.name, required super.description, required super.order});

  @override
  void performAction(BuildContext context, PlayersManager gameManager) {
    print("La Voyante peut voir le rôle d'un joueur.");
       showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Voyante"),
          content: ListView(
            children: gameManager.getPlayers().map((player) {
              return ListTile(
                title: Text(player.name),
                onTap: () {
                  seeRole(player.name, gameManager);
                  Navigator.of(context).pop();
                  
              
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
  void seeRole(String playerName, PlayersManager gameManager) {
  Player? player = gameManager.getPlayerByName(playerName);
  if (player == null) {
    print("Le joueur $playerName n'existe pas.");
    return;
  } else {
    print("Le rôle de $playerName est : ${player.role}");
  }
}
}
