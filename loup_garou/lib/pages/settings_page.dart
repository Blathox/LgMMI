import 'package:flutter/material.dart';
import 'package:loup_garou/visuals/colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Divider(thickness: 1, color: yellow),
            const SizedBox(height: 16),
            _buildSettingItem('Compte utilisateur'),
            _buildSettingItem('Réglages'),
            _buildSettingItem('Langues'),
            _buildSettingItem('Mentions légales'),
            _buildSettingItem('Sécurité et Confidentialité'),
            _buildSettingItem('Nouveautés'),
            const Spacer(),
            _buildSettingItem('Se déconnecter', isHighlighted: true),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: yellow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          onTap: () {
            // Placeholder for navigation or action
          },
        ),
      ),
    );
  }
}
