import 'dart:async';

import 'package:flutter/material.dart';
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

    if (newGameCode != null && newGameCode != 'Code introuvable') {
      setState(() {
        gameCode = newGameCode;
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

    // Charger les joueurs initiaux
    await _loadPlayers();

    // Écouter les mises à jour en temps réel depuis Supabase
    _gameStreamSubscription = Supabase.instance.client
        .from('GAMES')
        .stream(primaryKey: ['id'])
        .eq('game_code', gameCode ?? '')
        .listen((data) {
      if (mounted) {
        _loadPlayers();
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
          .select('users')
          .eq('game_code', gameCode ?? '')
          .single();

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
            if (playersManager.getPlayerByName(username) == null) {
              playersManager.addPlayer(Player(username, false));
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
              child: players.isNotEmpty
                  ? ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(players[index].name), // Affiche le nom du joueur
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Aucun joueur connecté pour le moment.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
