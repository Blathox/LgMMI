/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'package:loup_garou/visuals/variables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loup_garou/components/game_settings/counter.dart';

class PreparationPartiePage extends StatefulWidget {
  const PreparationPartiePage({super.key});

  @override
  State<PreparationPartiePage> createState() => _PreparationPartiePageState();
}

class _PreparationPartiePageState extends State<PreparationPartiePage> {
  PlayersManager playersManager = PlayersManager();
  List<Player> players = [];
  bool isLoading = true;
  StreamSubscription? _gameStreamSubscription;
  bool isHost = false;
  bool showPlayersView = true; // Vue active : Joueurs ou Paramètres
  GameSettingsManager settings = Globals.gameSettings;
  Map<String, bool> readyStatus = {}; // Statut "prêt/pas prêt" des joueurs

  @override
  void initState() {
    super.initState();
    Globals.playerManager =
        playersManager; // Initialise le playerManager global
    _initializeReadyStatus(); // Initialise les statuts "prêt"
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupérer les arguments passés à la page
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
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
    if (Globals.gameCode == '') {
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
          await _loadPlayers(); // Rafraîchir la liste des joueurs
        });
  }

  Future<void> _loadPlayers() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('GAMES')
          .select()
          .eq('game_code', Globals.gameCode);

      if (response.isEmpty) {
        print('Aucun jeu trouvé pour ce code.');
        return;
      }

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

          if (Globals.playerManager.getPlayerByName(username) == null) {
            Globals.playerManager.addPlayer(p);
          }

          // Initialiser les statuts à "pas prêt"
          readyStatus[p.idPlayer] = false;
        } catch (e) {
          print(
              'Erreur lors de la récupération de l\'utilisateur avec l\'ID $id : $e');
        }
      }

      if (mounted) {
        setState(() {
          players = Globals.playerManager.players;
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

  // Initialise les statuts "prêt/pas prêt"
  void _initializeReadyStatus() {
    for (var player in players) {
      readyStatus[player.idPlayer] =
          false; // Par défaut, tous les joueurs sont "pas prêts"
    }
  }

  // Bascule le statut "prêt/pas prêt" d'un joueur
  void toggleReady(String playerId) {
    setState(() {
      readyStatus[playerId] = !(readyStatus[playerId] ?? false);
    });
  }

// Build de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const Divider(thickness: 1, color: yellow),
            gameCodeDisplay(
              gameCode: Globals.gameCode,
              context: context, // Passez le contexte ici
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                _navigation(
                  context: context,
                  title: "Liste des joueurs",
                  icon: Icons.settings,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const playerList(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                _navigation(
                  context: context,
                  title: "Règlages",
                  icon: Icons.settings,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const settingsGameView(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Composant : Affiche la liste des joueurs dans la partie
// Paramètres : Liste des joueurs.
  Widget playerList({
    required List<Map<String, dynamic>> players, // Liste des joueurs
  }) {
    // Trier la liste pour mettre l'hôte en premier
    final sortedPlayers = [...players];
    sortedPlayers.sort((a, b) {
      if (a['isHost'] && !b['isHost']) return -1;
      if (!a['isHost'] && b['isHost']) return 1;
      return 0;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'Liste des joueurs :',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC107), // Jaune comme sur l'image
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: sortedPlayers.length,
            itemBuilder: (context, index) {
              final player = sortedPlayers[index];
              return playerTile(
                playerName: player['name'],
                isHost: player['isHost'],
                isReady: player['isReady'],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 5),
          ),
        ),
      ],
    );
  }

// Composant : Affichage d'un joueur
// Paramètres : Nom du joueur, Vérification si le joueur est hôte ou non, Vérification si le joueur est prêt ou non.
  Widget playerTile({
    required String playerName,
    required bool isHost,
    required bool isReady,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow, // Fond principal
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Zone diagonale colorée
          Align(
            alignment: Alignment.centerRight,
            child: ClipPath(
              clipper: _DiagonalClipper(),
              child: Container(
                width: 70,
                decoration: BoxDecoration(
                  color: isReady
                      ? Color(0xFF17BEBB)
                      : Color(0xFFFF4B14), // Vert si prêt, rouge sinon
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.3 * 255).toInt()),
                      blurRadius: 4,
                      offset: const Offset(-4, 0),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isReady ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          // Nom du joueur et couronne
          Row(
            children: [
              Expanded(
                child: Text(
                  playerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isHost)
                const Icon(
                  FontAwesomeIcons.crown, // Icône de couronne
                  color: Color(0xFFFF4B14),
                  size: 20,
                ),
            ],
          ),
        ],
      ),
    );
  }

// Composant : Affichage du code de la partie pour le copier et le partager
// Paramètres : code de la partie
Widget gameCodeDisplay({
  required String gameCode, // Le code de la partie à afficher
  required BuildContext context, // Passez le contexte pour afficher le SnackBar
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.yellow[700], // Fond jaune
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Affichage du code
        Text(
          'Code : $gameCode',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Bouton pour copier le code
        IconButton(
          icon: const Icon(Icons.copy, color: Colors.white),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: gameCode));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Code copié dans le presse-papier !'),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ],
    ),
  );
}


  Widget _buildSettingsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCounterRow(
          'Nombre de joueurs',
          settings.players.toString(),
          () => setState(() => settings.addPlayer()),
          () => setState(() => settings.removePlayer()),
        ),
        _buildCounterRow(
          'Durée du vote (en secondes)',
          settings.voteDuration.toString(),
          () => setState(() => settings.addTime()),
          () => setState(() => settings.removeTime()),
        ),
      ],
    );
  }

// Compteur utile dans la section paramètres (Exemple : compter le nombres de joueurs ou le nombres de loup-garou dans une partie)
  Widget _buildCounterRow(
      String label, String value, VoidCallback onAdd, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Counter(
              valueCounter: value, addCounter: onAdd, removeCount: onRemove),
        ],
      ),
    );
  }
}

// Header
Widget _header(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
    child: Row(
      children: [
        Text(
          'Préparation de la partie',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: yellow,
          ),
        ),
      ],
    ),
  );
}

// Widget pour faire un bouton de navigation
Widget _navigation({
  required BuildContext context,
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Container(
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    ),
  );
}

// Class qui permet de faire le clipper incliné sur les Tiles des joueurs
class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.25, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
*/