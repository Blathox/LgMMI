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

    if (gameResponse['id'] == null || gameResponse['users'] == null) {
      sm.showSnackBar(
        const SnackBar(content: Text("Code de partie invalide")),
      );
      return false;
    }

    final existingUsers = List<String>.from(gameResponse['users'] ?? []);

    // Vérifie l'utilisateur actuel
    final currentUser = supabase.auth.currentUser;
    if (currentUser == null) {
      sm.showSnackBar(
        const SnackBar(content: Text("Utilisateur non authentifié")),
      );
      return false;
    }


    // Vérifie si l'utilisateur est déjà dans la liste
    if (existingUsers.contains(Globals.userId)) {
      sm.showSnackBar(
        const SnackBar(content: Text("Vous avez déjà rejoint cette partie")),
      );
      return true;
    }

    // Ajoute l'utilisateur à la partie
    existingUsers.add(Globals.userId);

    final updateResponse = await supabase
        .from('GAMES')
        .update({'users': existingUsers})
        .eq('game_code', code)
        .select('id').single(); 
      Globals.gameId= updateResponse['id'];
      Globals.gameCode= code;
      // ignore: avoid_print
      print('gameId ${Globals.gameId}');
    if (updateResponse.isEmpty) {
      sm.showSnackBar(
        const SnackBar(content: Text("Erreur lors de la mise à jour de la partie")),
      );
      return false;
    }

    sm.showSnackBar(
      SnackBar(content: Text("Partie rejointe avec succès ! Code : $code")),
    );
    return true;
  } catch (e) {
    sm.showSnackBar(
      SnackBar(content: Text("Erreur inattendue : $e")),
    );
    return false;
  }
}
