import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'package:loup_garou/utils/fetchRoles.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  bool _showRules = true;
  final List<bool> _expandedRoles = [];
  late final Future<List<Map<String, dynamic>>> _rolesFuture;

  @override
  void initState() {
    super.initState();
    _rolesFuture = fetchRoles();
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
          'Le Loup-Garou est un jeu de rôle et de déduction où les joueurs incarnent des Villageois, des Loups-Garous ou des personnages spéciaux, le jeu alterne entre la Nuit, où les Loups-Garous désignent secrètement une victime et où certains personnages spéciaux utilisent leurs pouvoirs, et le Jour, où tous les joueurs débattent et votent pour éliminer un suspect, l’objectif des Villageois est de découvrir et éliminer tous les Loups-Garous, tandis que ces derniers cherchent à éliminer suffisamment de Villageois pour devenir majoritaires, le jeu prend fin lorsque l’un des deux camps atteint son objectif.',
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
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _rolesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        final roles = snapshot.data ?? [];
        if (roles.isEmpty) {
          return const Center(child: Text('Aucun rôle trouvé.'));
        }

        _ensureExpandedStatesInitialized(roles.length);

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
                itemCount: roles.length,
                itemBuilder: (context, index) => _buildRoleItem(roles[index], index),
              ),
            ),
          ],
        );
      },
    );
  }

  void _ensureExpandedStatesInitialized(int length) {
    if (_expandedRoles.length != length) {
      _expandedRoles.clear();
      _expandedRoles.addAll(List.generate(length, (_) => false));
    }
  }

  Widget _buildRoleItem(Map<String, dynamic> role, int index) {
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
                Row(
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (_) {},
                    ),
                    Text(
                      role['name'] ?? 'Sans nom',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
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
          Column(
            children: [
              _buildImageContainer('assets/images/image${index + 1}.svg'),
              const SizedBox(height: 8),
              Text(
                role['description'] ?? 'Pas de description.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
            ],
          ),
      ],
    );
  }
}