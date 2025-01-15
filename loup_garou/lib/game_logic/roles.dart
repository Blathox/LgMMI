import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:loup_garou/game_logic/players_manager.dart';

// Classe abstraite pour tous les rôles
abstract class RoleAction {
  final String name;
  final int order;
  final String description;

  RoleAction({
    required this.name,
    required this.description,
    required this.order,
  });

  void performAction(BuildContext context, PlayersManager playersManager);

   
}

// Classe Villageois
class Villageois extends RoleAction {
  Villageois({
    required super.name,
    required super.description,
    required super.order,
  });

  @override
  void performAction(BuildContext context, PlayersManager playersManager) {
    print("Le Villageois participe aux votes pour éliminer un joueur.");
  }
}

// Classe Loup-Garou
class LoupGarou extends RoleAction {
  List<String> availableTargets = [];
  String? chosenTarget;

  LoupGarou({
    required super.name,
    required super.description,
    required super.order,
  });

  @override
  void performAction(BuildContext context, PlayersManager playersManager) {
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
    print("Cibles disponibles pour les Loups-Garous : ${availableTargets.join(', ')}");
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
    // Logique pour mettre à jour l'état du joueur dans le jeu.
  }
}

// Classe Sorcière (hérite de Villageois)
class Sorciere extends Villageois {
  Sorciere({
    required super.name,
    required super.description,
    required super.order,
  });

  @override
  void performAction(BuildContext context, PlayersManager playersManager) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Action de la Sorcière"),
          content: Text(
            "Le joueur ${playersManager.getPlayerTargeted()?.getName() ?? 'aucun'} a été tué. Voulez-vous le sauver, tuer quelqu'un d'autre ou ne rien faire ?",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Player? targetedPlayer = playersManager.getPlayerTargeted();
                if (targetedPlayer != null) {
                  savePlayer(targetedPlayer, playersManager);
                } else {
                  print("Aucun joueur n'a été tué.");
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
                        children: playersManager.playerList.map((player) {
                          return ListTile(
                            title: Text(player.getName()),
                            onTap: () {
                              killPlayer(player, playersManager);
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

  void savePlayer(Player player, PlayersManager playersManager) {
    player.revive();
    print("La Sorcière a sauvé ${player.getName()}.");
  }

  void killPlayer(Player player, PlayersManager playersManager) {
    player.killed();
    print("La Sorcière a éliminé ${player.getName()}.");
  }
}

// Classe Chasseur (hérite de Villageois)
class Chasseur extends Villageois {
  Chasseur({
    required super.name,
    required super.description,
    required super.order,
  });

  @override
  void performAction(BuildContext context, PlayersManager playersManager) {
    print("Le Chasseur peut éliminer un joueur avant de mourir.");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Chasseur"),
          content: ListView(
            children: playersManager.playerList.map((player) {
              return ListTile(
                title: Text(player.getName()),
                onTap: () {
                  killPlayer(player, playersManager);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void killPlayer(Player player, PlayersManager playersManager) {
    player.killed();
    print("Le Chasseur a éliminé ${player.getName()}.");
  }
}

// Classe Cupidon (hérite de Villageois)
class Cupidon extends Villageois {
  Cupidon({
    required super.name,
    required super.description,
    required super.order,
  });

  @override
  void performAction(BuildContext context, PlayersManager playersManager) {
    print("Cupidon relie deux joueurs par les liens de l'amour.");
    List<String> playersSelected = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cupidon"),
          content: ListView(
            children: playersManager.playerList.map((player) {
              return ListTile(
                title: Text(player.getName()),
                onTap: () {
                  playersSelected.add(player.getName());
                  if (playersSelected.length == 2) {
                    linkPlayers(playersSelected[0], playersSelected[1], playersManager);
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

  void linkPlayers(String player1, String player2, PlayersManager playersManager) {
    Player? p1 = playersManager.getPlayerByName(player1);
    Player? p2 = playersManager.getPlayerByName(player2);
    if (p1 == null || p2 == null) {
      print("Les joueurs $player1 et $player2 doivent être présents dans la partie.");
      return;
    }
    playersManager.addPlayerLinked(p1, p2);
    print("Vous avez lié $player1 et $player2.");
  }
}

// Classe Voyante (hérite de Villageois)
class Voyante extends Villageois {
  Voyante({
    required super.name,
    required super.description,
    required super.order,
  });

  @override
  void performAction(BuildContext context, PlayersManager playersManager) {
    print("La Voyante peut voir le rôle d'un joueur.");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Voyante"),
          content: ListView(
            children: playersManager.playerList.map((player) {
              return ListTile(
                title: Text(player.getName()),
                onTap: () {
                  seeRole(player.getName(), playersManager);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void seeRole(String playerName, PlayersManager playersManager) {
    Player? player = playersManager.getPlayerByName(playerName);
    if (player == null) {
      print("Le joueur $playerName n'existe pas.");
      return;
    }
    print("Le rôle de $playerName est : ${player.role}");
  }
}
