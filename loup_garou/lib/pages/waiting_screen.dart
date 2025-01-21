import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/visuals/variables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../game_logic/player.dart';

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
    if (Globals.gameCode.isEmpty) {
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
      final updatedPlayers = updatedGame['users'] ?? [];

      if (updatedGame['status'] == "started") {
        if (mounted) {
          Navigator.pushNamed(context, '/game');
        }
        return;
      }

      // Vérifier les mises à jour des joueurs
      setState(() {
        players = Globals.playerManager.players;
      });

      if (updatedPlayers.length != players.length) {
        await _loadPlayers(); // Rafraîchir les joueurs si nécessaire
      }
    });
  }

  Future<void> _loadPlayers() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('GAMES')
          .select()
          .eq('game_code', Globals.gameCode)
          .single();

      final List<dynamic> playerIds = response['users'] ?? [];

      // Charger les joueurs en parallèle
      final playersData = await Future.wait(playerIds.map((id) async {
        try {
          final userResponse = await Supabase.instance.client
              .from('USERS')
              .select('username')
              .eq('id', id)
              .single();

          final String username = userResponse['username'];
          Player player = Player(username, false);
          player.idPlayer = id;
          Globals.playerManager.addAlivePlayer(player);

          if (Globals.playerManager.getPlayerByName(username) == null) {
            Globals.playerManager.addPlayer(player);
          }
          return player;
        } catch (e) {
          print('Erreur lors de la récupération de l\'utilisateur avec l\'ID $id : $e');
          return null;
        }
      }));

      setState(() {
        players = playersData.whereType<Player>().toList();
      });
    } catch (e) {
      print('Erreur lors du chargement des joueurs : $e');
    } finally {
      setState(() {
        isLoading = false;
      });
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
                      onPressed: () async {
                        try {
                          await Supabase.instance.client
                              .from('GAMES')
                              .update({'status': 'started'})
                              .eq('game_code', Globals.gameCode);
                          if (mounted) {
                            Navigator.pushNamed(context, '/game', arguments: {
                              'isHost': isHost,
                            });
                          }
                        } catch (e) {
                          print('Erreur lors du démarrage de la partie : $e');
                        }
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
