import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'package:random_string/random_string.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> createGame(
    BuildContext context, Map<String, dynamic> settings) async {
  
  final supabase = Supabase.instance.client;
  final sm = ScaffoldMessenger.of(context);
  final String codeGame = randomAlphaNumeric(6).toUpperCase();
  final rolesNames = (settings['rolesSelected'] as List<RoleAction>)
      .map((role) => role.name)
      .toList();
  final date = DateTime.now();

  // Mettre à jour settings avec les noms des rôles
  settings['rolesSelected'] = rolesNames;
  print(settings);
   final authResponse = await supabase.from('GAMES').insert({'settings': settings, 'game_code': codeGame, 'status': 'waiting', 'created_at': date.toIso8601String(), 'updated_at':date.toIso8601String() });

  sm.showSnackBar(
      SnackBar(content: Text("Game created with code Game : $codeGame $authResponse")));
  
}