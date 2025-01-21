import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loup_garou/game_logic/player.dart'; 
import 'package:loup_garou/game_logic/roles.dart'; 

class RolePage extends StatefulWidget {
  final RoleAction role;

  const RolePage({Key? key, required this.role}) : super(key: key);

  @override
  _RolePageState createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> with SingleTickerProviderStateMixin {
  late Color backgroundColor;
  bool showDescription = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
  
    // Déterminer la couleur de fond en fonction du rôle
    backgroundColor = _getRoleColor(widget.role);

    // Initialiser le contrôleur d'animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Définir les animations
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _positionAnimation = Tween<double>(begin: 0.0, end: -50.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Lancer les animations après 5 secondes
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showDescription = true;
      });
      _controller.forward();
    });

    // Naviguer vers la page du jeu après 15 secondes
    Future.delayed(const Duration(seconds: 15), () {
      Navigator.of(context).pushReplacementNamed('/gamePage');
    });
  }

  Color _getRoleColor(RoleAction role) {
    // Groupes de rôles par alignement
    if (role is LoupGarou || role.name.toLowerCase() == 'loup blanc') {
      return Colors.red[400]!; // Rouge : contre le village
    } else if (role is Villageois || role.name.toLowerCase() == 'cupidon') {
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
                          widget.role.name.toLowerCase() == 'loup-garou'
                              ? 'https://example.com/loup-garou.svg' // Exemple d'URL
                              : 'https://example.com/other.svg',
                          height: 150,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  widget.role.name,
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
                      widget.role.description,
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
