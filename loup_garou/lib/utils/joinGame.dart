import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../visuals/variables.dart';

Future<bool> joinGame(BuildContext context, String code) async {
  final supabase = Supabase.instance.client;
  final sm = ScaffoldMessenger.of(context);

  try {
    // Vérifie si la partie existe avec le code donné
    final gameResponse = await supabase
        .from('GAMES')
        .select()
        .eq('game_code', code)
        .single();

    if (gameResponse['id'] == null) {
      sm.showSnackBar(
        const SnackBar(content: Text("Code de partie invalide")),
      );
      return;
    }

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


    // Vérifie si l'utilisateur est déjà dans la liste
    if (existingUsers.contains(Globals.userId)) {
      sm.showSnackBar(
        const SnackBar(content: Text("Vous avez déjà rejoint cette partie")),
      );
      return;
    }

    // Ajoute l'utilisateur à la partie
    existingUsers.add(Globals.userId);

    final updateResponse = await supabase
        .from('GAMES')
        .update({'users': existingUsers})
        .eq('game_code', code)
        .select(); 

    if (updateResponse.error != null) {
      sm.showSnackBar(
        SnackBar(content: Text("Erreur : ${updateResponse.error!.message}")),
      );
      return;
    }
    Globals.gameCode = code;
    sm.showSnackBar(
      SnackBar(content: Text("Partie rejointe avec succès ! Code : $code")),
    );
  } catch (e) {
    sm.showSnackBar(
      SnackBar(content: Text("Erreur inattendue : $e")),
    );
  }
}
