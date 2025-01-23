import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'package:loup_garou/visuals/variables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<RoleAction> listeRoles = [];
  bool isLoading = true;
  bool isNight = true;
  String phaseTitle = "Phase Nuit";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    try {
      // Initialisation des rôles à partir de Supabase
      for (var role in Globals.gameSettings.rolesSelected) {
        final response = await Supabase.instance.client
            .from('ROLES')
            .select()
            .eq('name', role.getName)
            .maybeSingle();
        
        if (response == null) {
          print('Erreur lors de la récupération du rôle $role : $response');
          continue;
        }

        // Ajouter les rôles à la liste
        switch (role.getName) {
          case 'Loup-Garou':
            listeRoles.add(LoupGarou(
              description: response['description'],
              order: response['order'],
            ));
            break;
          case 'Villageois':
            listeRoles.add(Villageois(
              description: response['description'],
              order: response['order'] ?? 0,
            ));
            break;
          case 'Sorcière':
            listeRoles.add(Sorciere(
              description: response['description'],
              order: response['order'],
            ));
            break;
          case 'Chasseur':
            listeRoles.add(Chasseur(
              description: response['description'],
              order: response['order'],
            ));
            break;
          case 'Cupidon':
            listeRoles.add(Cupidon(
              description: response['description'],
              order: response['order'],
            ));
            break;
          case 'Voyante':
            listeRoles.add(Voyante(
              description: response['description'],
              order: response['order'],
            ));
            break;
          default:
            print('Rôle inconnu : $role');
            break;
        }
      }

      // Initialiser le game manager
      Globals.gameManager.setRoles = listeRoles;
      Globals.gameManager.playersManager = Globals.playerManager;
      print('Roles: $listeRoles');

      // Attribuer les rôles et commencer le jeu
      Globals.gameManager.attribuerRoles();
      Globals.gameManager.startGame(context, Globals.gameCode);

      // Mettre à jour l'état une fois le chargement terminé
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      // Lancer la première phase de jeu
      Globals.gameManager.processGame(context);
    } catch (e) {
      print('Erreur pendant l\'initialisation : $e');
    }
  }

  void startDiscussionPhase() {
    setState(() {
      isNight = false;
      phaseTitle = "Phase Jour - Discussion";
    });

    // Simuler un délai de discussion (exemple : 30 secondes)
    Future.delayed(Duration(seconds: Globals.gameSettings.voteDuration), () {
      startVotingPhase();
    });
  }

  void startVotingPhase() {
    setState(() {
      phaseTitle = "Phase Jour - Temps de Vote";
    });

    // Simuler un délai pour le vote (exemple : 20 secondes)
    Future.delayed(Duration(seconds: Globals.gameSettings.voteTime), () {
      setState(() {
        // Revenir à la phase de nuit
        isNight = true;
        phaseTitle = "Phase Nuit";
        Globals.gameManager.processGame(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isNight ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isNight ? Colors.black : Colors.white,
        foregroundColor: isNight ? Colors.white : Colors.black,
        title: Text(
          phaseTitle,
          style: TextStyle(
            color: isNight ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Informations sur le jeu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Joueurs : ${Globals.playerManager.playerList.length}',
                      style: TextStyle(
                        color: isNight ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      'Phase : ${Globals.gameManager.gamePhase.currentPhase}',
                      style: TextStyle(
                        color: isNight ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Message dynamique du jeu
                Text(
                  Globals.gameManager.getMessage,
                  style: TextStyle(
                    color: isNight ? Colors.white : Colors.black,
                  ),
                ),

                // Liste des joueurs
                Expanded(
                  child: ListView.builder(
                    itemCount: Globals.playerManager.playerList.length,
                    itemBuilder: (context, index) {
                      final player = Globals.playerManager.playerList[index];
                      return ListTile(
                        title: Text(
                          player.getName(),
                          style: TextStyle(
                            color: isNight ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          player.isAlive
                              ? "En vie"
                              : "Éliminé (${player.isTargeted ? 'ciblé' : ''})",
                          style: TextStyle(
                            color: isNight ? Colors.grey : Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Affichage du rôle actuel du joueur (pour l'interface joueur)
                if (Globals.playerManager.getPlayerById(Globals.userId) != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        Globals.playerManager.getPlayerById(Globals.userId).getName(),
                        style: TextStyle(
                          color: isNight ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        Globals.playerManager
                            .getPlayerById(Globals.userId)
                            .getRoleName(),
                        style: TextStyle(
                          color: isNight ? Colors.grey : Colors.black54,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
