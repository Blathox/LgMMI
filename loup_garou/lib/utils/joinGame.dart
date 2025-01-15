import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> joinGame(BuildContext context, String code) async {
  final supabase = Supabase.instance.client;
  final sm = ScaffoldMessenger.of(context);

  try {
    // Vérifie si la partie existe avec le code donné
    final gameResponse = await supabase
        .from('GAMES')
        .select('id, users')
        .eq('game_code', code)
        .single();

    if (gameResponse['id'] == null) {
      sm.showSnackBar(
        const SnackBar(content: Text("Code de partie invalide")),
      );
      return;
    }

    final gameId = gameResponse['id'];
    final existingUsers = gameResponse['users'] as List<dynamic>? ?? [];

    // Vérifie l'utilisateur actuel
    final userResponse = await supabase
        .from('USERS')
        .select('id')
        .eq('id_user', supabase.auth.currentUser!.id)
        .single();

    if (userResponse['id'] == null) {
      sm.showSnackBar(
        const SnackBar(content: Text("Utilisateur introuvable")),
      );
      return;
    }

    final userId = userResponse['id'];
    // Vérifie si l'utilisateur est déjà dans la liste
    if (existingUsers.contains(userId)) {
      sm.showSnackBar(
        const SnackBar(content: Text("Vous avez déjà rejoint cette partie")),
      );
      return;
    }

    // Ajoute l'utilisateur à la partie
    existingUsers.add(userId);
    final updateResponse = await supabase
        .from('GAMES')
        .update({'users': existingUsers})
        .eq('game_code', code);

    if (updateResponse.error != null) {
      sm.showSnackBar(
        SnackBar(content: Text("Erreur : ${updateResponse.error!.message}")),
      );
      return;
    }

    sm.showSnackBar(
      SnackBar(content: Text("Partie rejointe avec succès ! Code : $code")),
    );
  } catch (e) {
    sm.showSnackBar(
      SnackBar(content: Text("Erreur inattendue : $e")),
    );
  }
}
