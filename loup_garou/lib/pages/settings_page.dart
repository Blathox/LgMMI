import 'package:flutter/material.dart';
import 'package:loup_garou/visuals/colors.dart';
import 'package:loup_garou/utils/signOut.dart';
import 'package:loup_garou/utils/user_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, "Paramètres"),
            const Divider(thickness: 1, color: yellow),
            const SizedBox(height: 16),
            _buildNavigationButton(
              context: context,
              title: "Compte utilisateur",
              icon: Icons.person,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountPage(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildNavigationButton(
              context: context,
              title: "Réglages",
              icon: Icons.settings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsDetailPage(),
                ),
              ),
            ),
            const Spacer(),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: yellow),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Text(
            title,
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

  Widget _buildNavigationButton({
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

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: const Icon(Icons.logout, color: Colors.white),
          title: const Text(
            'Se déconnecter',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () {
            showLogoutConfirmationDialog(context);
          },
        ),
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final UserService _userService = UserService();
  String pseudo = "Utilisateur";
  String email = "email@example.com";
  String creationDate = "N/A";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final data = await _userService.fetchUserData();
      setState(() {
        pseudo = data['username'] ?? 'Utilisateur non trouvé';
        email = data['email'] ?? 'Email non trouvé';
        creationDate = data['creationDate'] ?? 'Date non trouvée';
      });
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> _updatePseudo(String newPseudo) async {
  try {
    final response = await _userService.updatePseudo(newPseudo);

    // Vérifier si la réponse n'est pas nulle et si l'update a réussi
    if (response != null && response['error'] == null) {
      setState(() {
        pseudo = newPseudo;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pseudo mis à jour avec succès!')),
      );
    } else {
      // Si une erreur est retournée par Supabase, afficher l'erreur
      final errorMessage = response != null ? response['error'] ?? 'Erreur inconnue' : 'Réponse nulle';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour du pseudo: $errorMessage')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur : $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, "Compte utilisateur"),
            const Divider(thickness: 1, color: yellow),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pseudo : $pseudo",
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: yellow),
                        onPressed: _showEditDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Email : $email",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Date de création : $creationDate",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: yellow),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Text(
            title,
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

  void _showEditDialog() {
    final TextEditingController controller = TextEditingController(text: pseudo);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier le pseudo"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Entrez un nouveau pseudo"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: yellow),
              onPressed: () async {
                final newPseudo = controller.text.trim();
                if (newPseudo.isNotEmpty && newPseudo != pseudo) {
                  await _updatePseudo(newPseudo);
                }
                Navigator.pop(context);
              },
              child: const Text("Sauvegarder"),
            ),
          ],
        );
      },
    );
  }
}

class SettingsDetailPage extends StatelessWidget {
  const SettingsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, "Réglages"),
            const Divider(thickness: 1, color: yellow),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                "Suspendisse potenti. Phasellus euismod.",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: yellow),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Text(
            title,
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
}

// Boite de dialog pour la déconnexion
Future<void> showLogoutConfirmationDialog(BuildContext context) async {
  final bool? shouldLogout = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmer la déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Ferme le dialog sans action
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true); // Ferme et confirme la déconnexion
            },
            child: const Text('Se déconnecter'),
          ),
        ],
      );
    },
  );

  // Si l'utilisateur confirme la déconnexion, effectuer la déconnexion
  if (shouldLogout == true) {
    await signOut(context);
  }
}