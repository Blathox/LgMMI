import 'package:flutter/material.dart';
import 'package:loup_garou/components/game_settings/counter.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'package:loup_garou/utils/createGame.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'package:loup_garou/visuals/variables.dart';
import 'package:random_string/random_string.dart';

class GameSettingsScreen extends StatefulWidget {
  const GameSettingsScreen({super.key});

  @override
  _GameSettingsScreenState createState() => _GameSettingsScreenState();
}

class _GameSettingsScreenState extends State<GameSettingsScreen> {

  @override
  void initState() {
    super.initState();
    Globals.gameSettings = GameSettingsManager(300);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres de la partie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Nombre de joueurs',
                  style: Theme.of(context).textTheme.bodyMedium),
              Counter(
                  valueCounter: Globals.gameSettings.players.toString(),
                  addCounter: () => setState(() => Globals.gameSettings.addPlayer()),
                  removeCount: () =>
                      setState(() => Globals.gameSettings.removePlayer()))
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Durée du vote (en secondes)',
                  style: Theme.of(context).textTheme.bodyMedium),
              Counter(
                  valueCounter: Globals.gameSettings.voteDurations.toString(),
                  addCounter: () => setState(() => Globals.gameSettings.addTime()),
                  removeCount: () => setState(() => Globals.gameSettings.removeTime()))
            ]),
            Text('Choisissez les rôles de la partie',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Nombre de colonnes
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1, // Ajustez ce ratio selon vos besoins
                ),
                itemCount: Globals.gameSettings.roles.length,
                itemBuilder: (context, index) {
                  final role = Globals.gameSettings.roles[index];
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (Globals.gameSettings.rolesSelected.contains(role)) {
                        Globals.gameSettings.removeRole(role);
                      } else {
                        Globals.gameSettings.addRole(role);
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Globals.gameSettings.rolesSelected.contains(role)
                              ? yellow
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.info),
                                onPressed: () {
                                  _showRoleDetails(context, role);
                                },
                              ),
                            ],
                          ),
                          Text(
                            role.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (role.name == 'Villageois') ...[
                            Text(Globals.gameSettings.villagers.toString()),
                          ],
                          if (role.name == 'Loup-Garou') ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Counter(
                                    valueCounter:
                                        Globals.gameSettings.nbWolves.toString(),
                                    addCounter: () {
                                      setState(() {
                                        print("test");
                                        if (Globals.gameSettings.getRoleCount('Villageois') >0) {
                                          print('pqsoicj');
                                          Globals.gameSettings.addWolf();
                                        }
                                      });
                                    },
                                    removeCount: () {
                                      setState(() {
                                        if (Globals.gameSettings.wolves > 1) {
                                          Globals.gameSettings.removeWolf();
                                        }
                                      });
                                    })
                              ],
                            ),
                          ] else ...[
                            if (role.name != 'Villageois') ...[
                              Counter(
                                  valueCounter: Globals.gameSettings
                                      .getRoleCount(role.name)
                                      .toString(),
                                  addCounter: () {
                                    setState(() {
                                      if (Globals.gameSettings.getRoleCount(role.name) <
                                              1 &&
                                          Globals.gameSettings
                                                  .getRoleCount("Villageois") >
                                              1) {
                                        Globals.gameSettings.addRole(role);
                                        Globals.gameSettings.villagers--;
                                      }
                                    });
                                  },
                                  removeCount: () {
                                    setState(() {
                                      if (Globals.gameSettings.getRoleCount(role.name) >
                                          0) {
                                        Globals.gameSettings.removeRole(role);
                                        Globals.gameSettings.villagers++;
                                      }
                                    });
                                  })
                            ]
                          ]
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  final sm = ScaffoldMessenger.of(context);

                  try {
                    final String codeGame = randomAlphaNumeric(6).toUpperCase();

                    createGame(
                        context,
                        Globals.gameSettings,
                        codeGame);
                        Globals.gameCode = codeGame;
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamed(context, '/waitingScreen',
                        arguments: {'isHost': true});
                  } catch (e) {
                    sm.showSnackBar(SnackBar(
                        content: Text(
                            "Erreur lors de la création de la partie: $e")));
                  }
                },
                child: const Text('Créer une partie'))
          ],
        ),
      ),
    );
  }

  // Méthode pour afficher les détails d'un rôle
  void _showRoleDetails(BuildContext context, RoleAction role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(role.name),
          content: Text(role.description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }
}
