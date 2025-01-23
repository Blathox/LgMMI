import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'package:loup_garou/game_logic/roles.dart'; // Import des classes de rôles

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  bool _showRules = true;
  final List<bool> _expandedRoles = [];

  // Liste des rôles (instanciés à partir de leurs classes)
  final List<RoleAction> _roles = [
    Villageois(description: "Un simple villageois qui participe aux votes.", order: 0),
    LoupGarou(description: "Élimine les villageois chaque nuit sans se faire démasquer.", order: 1),
    Sorciere(description: "Possède deux potions pour sauver ou éliminer un joueur.", order: 2),
    Chasseur(description: "Peut éliminer un joueur avant de mourir.", order: 3),
    Cupidon(description: "Lie deux joueurs par les liens de l’amour.", order: 4),
    Voyante(description: "Peut découvrir le rôle d’un joueur chaque nuit.", order: 5),
  ];

  @override
  void initState() {
    super.initState();
    _expandedRoles.addAll(List.generate(_roles.length, (_) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(color: yellow),
            const SizedBox(height: 15),
            _buildToggleButtons(),
            Expanded(
              child: _showRules ? _buildRulesContent() : _buildRolesContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: yellow),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 10),
        const Text(
          'Règles & Rôles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: yellow,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildToggleButton(
            title: 'Règles',
            isSelected: _showRules,
            onPressed: () => setState(() => _showRules = true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildToggleButton(
            title: 'Rôles',
            isSelected: !_showRules,
            onPressed: () => setState(() => _showRules = false),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRulesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Règles du jeu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Le Loup-Garou est un jeu de rôle et de déduction où les joueurs incarnent des Villageois, des Loups-Garous ou des personnages spéciaux...',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _buildImageContainer('assets/images/image1.svg'),
        ),
      ],
    );
  }

  Widget _buildImageContainer(String assetPath) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: yellow.withOpacity(0.5),
      ),
      child: SvgPicture.asset(
        assetPath,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRolesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Rôles dans le jeu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _roles.length,
            itemBuilder: (context, index) => _buildRoleItem(_roles[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleItem(RoleAction role, int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expandedRoles[index] = !_expandedRoles[index]),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: yellow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  role.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                AnimatedRotation(
                  turns: _expandedRoles[index] ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        if (_expandedRoles[index])
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              role.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }
}
