// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_handler.dart';
import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/phases.dart';
import 'package:loup_garou/visuals/variables.dart';

class GameScreen extends StatelessWidget {
  final GameHandler gameHandler;

  GameScreen({required this.gameHandler});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Loup-Garou")),
      body: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: gameHandler.gameMessage,
            builder: (context, message, child) {
              return Text(message); // Affiche le message du jeu
            },
          ),
          ValueListenableBuilder<GamePhase>(
            valueListenable: gameHandler.currentPhase,
            builder: (context, phase, child) {
              return Text("Phase actuelle: ${phase.currentPhase}");
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: gameHandler.currentRole,
            builder: (context, role, child) {
              return Text("En attente des $role...");
            },
          ),
          ElevatedButton(
            onPressed: () => showRoleActions(context, gameHandler.currentRole.value),
            child: Text("Actions disponibles"),
          ),
          if (gameHandler.currentPhase.value.currentPhase == "Jour")
            Column(
              children: [
                Text("Votez pour un joueur"),
                ...gameHandler.playersManager.getLivingPlayers().map((player) {
                  return ListTile(
                    title: Text(player),
                    trailing: Text("Votes: ${gameHandler.playersManager.getVotes(player)}"),
                    onTap: () {
                      gameHandler.gameManager.voteFor(player);
                    },
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  void showRoleActions(BuildContext context, String role) {
    List<String> players = gameHandler.playersManager.getLivingPlayers();

    if (role == "Loup-Garou") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Choisissez une victime"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: players.map((player) {
              return ListTile(
                title: Text(player),
                onTap: () {
                  Navigator.pop(context);
                  gameHandler.gameManager.setVictim(player);
                },
              );
            }).toList(),
          ),
        ),
      );
    } else if (role == "Sorcière") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sorcière - Actions"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Sauver la victime"),
                onTap: () {
                  Navigator.pop(context);
                  gameHandler.gameManager.saveVictim();
                },
              ),
              ListTile(
                title: Text("Tuer un joueur"),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Choisissez une cible"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: players.map((player) {
                          return ListTile(
                            title: Text(player),
                            onTap: () {
                              Navigator.pop(context);
                              gameHandler.gameManager.setTarget(player);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else if (role == "Villageois") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Phase de vote"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: players.map((player) {
              return ListTile(
                title: Text(player),
                onTap: () {
                  Navigator.pop(context);
                  gameHandler.gameManager.voteFor(player);
                },
              );
            }).toList(),
          ),
        ),
      );
    }
  }
}
