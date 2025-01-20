import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  
  late Map<String, dynamic> gameSettings;
  late PlayersManager playersManager;
  late GameManager gameManager;
  List<RoleAction> listeRoles = []; // Initialisation correcte

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      gameSettings = args['settings'] as Map<String, dynamic>;
      playersManager = args['playersManager'] as PlayersManager;

      // Récupérer les rôles depuis Supabase
      for (var role in gameSettings['rolesSelected']) {
        final response = await Supabase.instance.client
            .from('ROLES')
            .select('name, description, order')
            .eq('name', role)
            .maybeSingle();

        if ( response == null) {
          print('Erreur lors de la récupération du rôle $role : $response');
          continue;
        }
        switch(role) {
          case 'Loup-Garou':
            listeRoles.add(LoupGarou(
              name: response['name'],
              description: response['description'],
              order: response['order'],
            ));
            break;
          case 'Villageois':
            listeRoles.add(Villageois(
              name: response['name'],
              description: response['description'],
              order: response['order']??0,
            ));
            break;
          case 'Sorcière':
            listeRoles.add(Sorciere(
              name: response['name'],
              description: response['description'],
              order: response['order'],
            ));
            break;
          case 'Chasseur':
            listeRoles.add(Chasseur(
              name: response['name'],
              description: response['description'],
              order: response['order'],
            ));
            break;
          case 'Cupidon':
            listeRoles.add(Cupidon(
              name: response['name'],
              description: response['description'],
              order: response['order'],
            ));
            break;
          case 'Voyante':
            listeRoles.add(Voyante(
              name: response['name'],
              description: response['description'],
              order: response['order'],
            ));
            break;
          default:
            print('Rôle inconnu : $role');
            break;
        }
       
      }

      gameManager = GameManager(listeRoles);
      print(args['gameId']);
      gameManager.startGame(context, args['gameCode'] as String);
    } else {
      throw Exception('Les arguments requis pour GameScreen sont manquants.');
    }
  }
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Screen'),
      ),
      body: 
    Column(
      children: [
        Row(
          children: [
            Text('Players: ${playersManager.playerList.length}'),
            Text('Phase: ${gameManager.gamePhase.currentPhase}'),
          ],   
        ),
        Text(gameManager.getMessage),

        // Add your game screen widgets here
      ],
    )); // Replace with your actual widget tree
  }
}
