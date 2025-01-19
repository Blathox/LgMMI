import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../game_logic/player.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final PlayersManager playersManager = PlayersManager();
  List<Player> players = [];
  bool isLoading = true;
  String? gameCode;
  StreamSubscription? _gameStreamSubscription;
  bool isHost = false;
  Map<String, dynamic> settings = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupérer les arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final newGameCode = args?['gameCode'];
  final newIsHost = args?['isHost'];

    if (newGameCode != null && newGameCode != 'Code introuvable') {
      setState(() {
        gameCode = newGameCode;
        isHost = newIsHost;
        
      });
      _initializeGame();
    } else {
      print('Erreur : Code de la partie introuvable.');
    }
  }

  @override
  void dispose() {
    _gameStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeGame() async {
  if (gameCode == null || gameCode == '') {
    print('Erreur : Code de la partie introuvable.');
    return;
  }

  await _loadPlayers();

  // Écouter les mises à jour en temps réel depuis Supabase
  _gameStreamSubscription = Supabase.instance.client
      .from('GAMES')
      .stream(primaryKey: ['id'])
      .eq('game_code', gameCode ?? '')
      .listen((data) async {
    if (data.isEmpty) return;

    final updatedGame = data.first;

    if (updatedGame['users'] != null) {
      final List<dynamic> updatedPlayers = updatedGame['users'];

      if (!updatedPlayers.contains(players.first.idPlayer)) {
        // L'administrateur s'est déconnecté
        if (mounted) {
          await Supabase.instance.client
              .from('GAMES')
              .delete()
              .eq('game_code', gameCode ??'');
          Navigator.pushNamed(context,'/gameMode', arguments: {
            'message': 'La partie a été annulée car l\'administrateur s\'est déconnecté.'
          });
        }
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
      // Récupérer les joueurs associés au code de la partie
      final response = await Supabase.instance.client
          .from('GAMES')
          .select()
          .eq('game_code', gameCode ?? '')
          .single();
          print('rep $response');
      setState(() {
        settings = response['settings'];
      });
      if (!mounted) return;

      if (response['users'] != null) {
        final List<dynamic> playerIds = response['users'];

        for (var id in playerIds) {
          try {
            
            final userResponse = await Supabase.instance.client
                .from('USERS')
                .select('username')
                .eq('id', id)
                .single();

            if (!mounted) return;

            final String username = userResponse['username'];
            Player p= Player(username, false);
            p.idPlayer = id;
            if (playersManager.getPlayerByName(username) == null) {
              playersManager.addPlayer(p);
            }
          } catch (e) {
            print('Erreur lors de la récupération de l\'utilisateur avec l\'ID $id : $e');
          }
        }
      }

      if (mounted) {
        setState(() {
          players = playersManager.players;
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
            'Code de la partie : $gameCode',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: Column(
                children: [
                  Text( 'Joueurs connectés : ${players.length}/${settings['nbJoueurs']}'),
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
                            .eq('game_code', gameCode as Object);
                        Navigator.pushNamed(context, '/game', arguments: {'gameCode': gameCode, 'playersManager': playersManager, 'settings': settings, 'isHost': isHost});
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
