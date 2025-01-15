import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'package:loup_garou/utils/fetchRoles.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({Key? key}) : super(key: key);

  @override
  _RulesPageState createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  bool showRules = true;
  List<bool> isExpanded = [];
  late Future<List<Map<String, dynamic>>> rolesFuture;

  @override
  void initState() {
    super.initState();
    rolesFuture = fetchRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: yellow,
                  ),
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
            ),
            const Divider(color: yellow),
            SizedBox(height: 15),
            // Boutons pour changer le contenu
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showRules ? Colors.orange : yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: () {
                      setState(() {
                        showRules = true;
                      });
                    },
                    child: const Text(
                      'Règles',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showRules ? yellow : Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: () {
                      setState(() {
                        showRules = false;
                      });
                    },
                    child: const Text(
                      'Rôles',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: showRules ? _buildRulesContent() : _buildRolesContent(),
            ),
          ],
        ),
      ),
    );
  }

  // Contenu des règles
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
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: yellow.withOpacity(0.5),
            ),
            child: SvgPicture.asset(
              'assets/images/image1.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRolesContent() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: rolesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun rôle trouvé.'));
        }

        final roles = snapshot.data!;

        // Initialiser la liste isExpanded avec le nombre d'éléments, si ce n'est pas déjà fait
        if (isExpanded.isEmpty) {
          isExpanded = List.generate(roles.length, (index) => false);
        }

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
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded[index] =
                                !isExpanded[index]; // Toggle l'état d'expansion
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
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
                                    onChanged: (value) {},
                                  ),
                                  Text(
                                    roles[index]['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedRotation(
                                turns: isExpanded[index] ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(Icons.chevron_right,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded[
                          index]) // Affichage conditionnel si le rôle est développé
                        Column(
                            children: [
                              Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: yellow.withOpacity(0.5),
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/image${index + 1}.svg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                roles[index]['description'] ??
                                    'Pas de description.',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              const SizedBox(height: 15),
                            ],
                            
                          ),
                          
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
