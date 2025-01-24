import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:loup_garou/game_logic/players_manager.dart'; 
import 'package:loup_garou/game_logic/roles.dart';
import 'package:loup_garou/visuals/variables.dart'; 
import 'package:loup_garou/game_logic/game_manager.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  _RolePageState createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> with SingleTickerProviderStateMixin {
  late Color backgroundColor;
  RoleAction? role;
  bool showDescription = false;
  final PlayersManager playerM = Globals.playerManager;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define animations
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _positionAnimation = Tween<double>(begin: 0.0, end: -50.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Delayed description display
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showDescription = true;
      });
      _controller.forward();
    });

    // Navigate to the game screen after 15 seconds
    Future.delayed(const Duration(seconds: 15), () {
      Navigator.of(context).pushReplacementNamed('/game_screen');
    });
  }

  Color _getRoleColor(RoleAction? role) {
    if (role is LoupGarou || role?.name.toLowerCase() == 'loup blanc') {
      return Colors.red[400]!; // Rouge : contre le village
    } else if (role is Villageois || role?.name.toLowerCase() == 'cupidon') {
      return Colors.green[300]!; // Vert : avec le village
    } else {
      return Colors.grey[400]!; // Gris : rôles solos
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get arguments from ModalRoute
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isHost = args?['isHost'] ?? false;

    // Retrieve player and role information
    final player = playerM.getPlayerById(Globals.userId);
    role = player?.getRole();
    backgroundColor = _getRoleColor(role);

    // If host, assign roles
    if (isHost) {
      Globals.gameManager.attribuerRoles();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Votre rôle :',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _positionAnimation.value),
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: SvgPicture.network(
                          role?.name.toLowerCase() == 'loup-garou'
                              ? 'https://example.com/loup-garou.svg' // Example URL
                              : 'https://example.com/other.svg',
                          height: 150,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  role?.getName ?? "Rôle inconnu",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (showDescription) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      role?.description ?? "Aucune description disponible.",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
