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
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    Globals.gameSettings = GameSettingsManager(300);
    await Globals.gameSettings.initializeRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres de la partie'),
      ),
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur lors de l'initialisation : ${snapshot.error}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          // Construire l'interface une fois l'initialisation terminée
          return _buildGameSettingsContent(context);
        },
      ),
    );
  }

  Widget _buildGameSettingsContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCounterRow(
            context,
            'Nombre de joueurs',
            Globals.gameSettings.players.toString(),
            () => setState(() => Globals.gameSettings.addPlayer()),
            () => setState(() => Globals.gameSettings.removePlayer()),
          ),
          _buildCounterRow(
            context,
            'Durée du vote (en secondes)',
            Globals.gameSettings.voteDuration.toString(),
            () => setState(() => Globals.gameSettings.addTime()),
            () => setState(() => Globals.gameSettings.removeTime()),
          ),
          Text('Choisissez les rôles de la partie',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          Expanded(
            child: _buildRolesGrid(context),
          ),
          TextButton(
            onPressed: () => _createGame(context),
            child: const Text('Créer une partie'),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterRow(BuildContext context, String label, String value,
      VoidCallback onAdd, VoidCallback onRemove) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Counter(
          valueCounter: value,
          addCounter: onAdd,
          removeCount: onRemove,
        ),
      ],
    );
  }

Widget _buildRolesGrid(BuildContext context) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // Nombre de colonnes
      crossAxisSpacing: 5.0,
      mainAxisSpacing: 5.0,
      childAspectRatio: 1, // Proportion largeur/hauteur
    ),
    itemCount: Globals.gameSettings.roles.length,
    itemBuilder: (context, index) {
      final role = Globals.gameSettings.roles[index];
      final isSelected = Globals.gameSettings.rolesSelected.contains(role);

      // Retourner le widget correctement
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? yellow : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildRoleInfoButton(context, role),
            Text(
              role.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Counter(
              valueCounter:
                  Globals.gameSettings.getRoleCount(role.name).toString(),
              addCounter: () => setState(() {
                Globals.gameSettings.toggleRole(role, true);
              }),
              removeCount: () => setState(() {
                Globals.gameSettings.toggleRole(role, false);
              }),
            ),
          ],
        ),
      );
    },
  );
}

  Widget _buildRoleInfoButton(BuildContext context, RoleAction role) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            _showRoleDetails(context, role);
          },
        ),
      ],
    );
  }

  Future<void> _createGame(BuildContext context) async {
    final sm = ScaffoldMessenger.of(context);

    try {
      final String codeGame = randomAlphaNumeric(6).toUpperCase();
      await createGame(context, Globals.gameSettings, codeGame);
      Globals.gameCode = codeGame;

      // Naviguer vers l'écran d'attente
      if (mounted) {
        Navigator.pushNamed(context, '/waitingScreen',
            arguments: {'isHost': true});
      }
    } catch (e) {
      sm.showSnackBar(
        SnackBar(content: Text("Erreur lors de la création de la partie: $e")),
      );
    }
  }

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
