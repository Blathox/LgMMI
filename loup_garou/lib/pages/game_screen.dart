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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    try {
      // Initialisation des rôles en fonction des paramètres du jeu
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

      // Mise à jour du game manager avec les rôles
      Globals.gameManager.setRoles = listeRoles;
      Globals.gameManager.playersManager = Globals.playerManager;
      print('Roles: $listeRoles');

      // Démarrer le jeu après initialisation
      Globals.gameManager.startGame(context, Globals.gameCode);

      // Mettre à jour l'état une fois le chargement terminé
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      // Attribuer les rôles et commencer le jeu
      Globals.gameManager.attribuerRoles();
      Globals.supabase.from('PLAYERS').insert({'game_id':Globals.gameId,'user_id': Globals.userId,'role': Globals.playerManager.getPlayerById(Globals.userId).getRole().getName,'status':true,'killedatnight':false});
      print('test');
      Globals.gameManager.processGame(context);
      
    } catch (e) {
      print('Erreur pendant l\'initialisation : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si le jeu est en cours d'initialisation, afficher un écran de chargement
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Screen'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Players: ${Globals.playerManager.playerList.length}'),
              Text('Phase: ${Globals.gameManager.gamePhase.currentPhase}'),
            ],
          ),
          const SizedBox(height: 10),
          Text(Globals.gameManager.getMessage),
          SizedBox(
            height: 200,
            child: ListTile(
              title: Text(Globals.playerManager.getPlayerById(Globals.userId).getName()),
              subtitle: Text(Globals.playerManager.getPlayerById(Globals.userId).getRoleName()),
            ),
          ),
        ],
      ),
    );
  }
}