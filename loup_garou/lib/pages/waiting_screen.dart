import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/pages/login_screen.dart';
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
  late String gameCode; // Contient le code de la partie

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
  }

  Future<void> _initializeGame() async {
    // Récupérer le code de la partie depuis les arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    gameCode = args?['gameCode'] ?? 'Code introuvable';

    if (gameCode == 'Code introuvable') {
      print('Erreur : Code de la partie introuvable.');
      return;
    }

    // Charger les joueurs initiaux
    await _loadPlayers();

    // Écouter les mises à jour en temps réel depuis Supabase
    Supabase.instance.client
        .from('GAMES')
        .stream(primaryKey: ['id'])
        .eq('game_code', gameCode)
        .listen((data) {
      _loadPlayers(); 
    });
  }

  Future<void> _loadPlayers() async {
    setState(() {
      isLoading = true;
    });

    try {
      print(gameCode);
      final response = await Supabase.instance.client
          .from('GAMES')
          .select('users')
          .eq('game_code', gameCode)
          .single();
print('test');
if (response['users'] != null) {

  final List<String> playerIds = List<String>.from(
    response['users'].map((player) => player.toString()), 
  );

  if (playerIds.isNotEmpty) {
    try {
      for(int i = 0; i < playerIds.length; i++){
      final usersResponse = await supabase
          .from('USERS')
          .select()
          .eq('id', playerIds[i]).single();
          
      if (playersManager.getPlayerByName(usersResponse['username'])==null) {
        
        final String username = usersResponse['username'] as String;
        playersManager.addPlayer(Player(username, false));
      }}
        } catch (e) {
      print('Erreur lors de la récupération des utilisateurs : $e');
    }
  }
}




        setState(() {
          players = playersManager.players;
          isLoading = false;
        });
      
    } catch (e) {
      print('Erreur lors du chargement des joueurs : $e');
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
