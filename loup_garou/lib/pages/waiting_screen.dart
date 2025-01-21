import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/visuals/variables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/player.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  PlayersManager playersManager = PlayersManager();
  List<Player> players = [];
  bool isLoading = true;
  StreamSubscription? _gameStreamSubscription;
  bool isHost = false;
  GameSettingsManager settings = Globals.gameSettings;

  @override
  void initState() {
    super.initState();
    // Initialise le playerManager dans les globals
    Globals.playerManager = playersManager;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupérer les arguments passés à l'écran
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final newIsHost = args?['isHost'];

    setState(() {
      isHost = newIsHost ?? false;
    });
    _initializeGame();
  }

  @override
  void dispose() {
    _gameStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeGame() async {
    if ( Globals.gameCode == '') {
      print(Globals.gameCode);
      print('Erreur : Code de la partie introuvable.');
      return;
    }

    await _loadPlayers();

    // Écouter les mises à jour en temps réel depuis Supabase
    _gameStreamSubscription = Supabase.instance.client
        .from('GAMES')
        .stream(primaryKey: ['id'])
        .eq('game_code', Globals.gameCode)
        .listen((data) async {
      if (data.isEmpty) return;
      final updatedGame = data.first;

      if (updatedGame['users'] != null) {
        final List<dynamic> updatedPlayers = updatedGame['users'];

        if (!updatedPlayers.contains(players.first.idPlayer)) {
          // Gérer la déconnexion de l'administrateur
        } else {
          await _loadPlayers(); // Rafraîchir la liste des joueurs
        }
      }
    });
  }

  Future<void> _loadPlayers() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

  

  

    try {
      print('gameCode: ${Globals.gameCode}');
      // Récupérer les joueurs associés au code de la partie
      final response = await Supabase.instance.client
          .from('GAMES')
          .select()
          .eq('game_code', Globals.gameCode);

      if (response.isEmpty) {
        print('Aucun jeu trouvé pour ce code.');
        return;
      }

      setState(() {
        print(response[0]['settings']);
        print("test");
      });

      if (!mounted) return;

      final List<dynamic> playerIds = response[0]['users'];

      for (var id in playerIds) {
        try {
          final userResponse = await Supabase.instance.client
              .from('USERS')
              .select('username')
              .eq('id', id)
              .single();

          if (!mounted) return;

          final String username = userResponse['username'];
          Player p = Player(username, false);
          p.idPlayer = id;
          Globals.playerManager.addAlivePlayer(p);

          if ( Globals.playerManager.getPlayerByName(username) == null) {
             Globals.playerManager.addPlayer(p);
          }
        } catch (e) {
          print('Erreur lors de la récupération de l\'utilisateur avec l\'ID $id : $e');
        }
      }

      if (mounted) {
        setState(() {
          players =  Globals.playerManager.players;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des joueurs : $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting for Players'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Code de la partie : ${Globals.gameCode}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: Column(
                children: [
                  Text('Joueurs connectés : ${players.length}/${settings.nbPlayers}'),
                  players.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: players.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(players[index].name), // Affiche le nom du joueur
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Aucun joueur connecté pour le moment.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                  if (players.isNotEmpty && isHost)
                    ElevatedButton(
                      onPressed: () {
                        Supabase.instance.client
                            .from('GAMES')
                            .update({'status': 'started'})
                            .eq('game_code', Globals.gameCode as Object);
                        Navigator.pushNamed(context, '/game', arguments: {
                          'isHost': isHost
                        });
                      },
                      child: const Text('Commencer la partie'),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
