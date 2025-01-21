import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'package:loup_garou/visuals/variables.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> createGame(
    BuildContext context, GameSettingsManager settings,String codeGame) async {
  
  final supabase = Supabase.instance.client;
  final sm = ScaffoldMessenger.of(context);

  final date = DateTime.now();

  // Mettre à jour settings avec les noms des rôles
print ('settings ${settings.rolesSelected}');
  
   final authResponse = await supabase.from('GAMES').insert({'settings': settings, 'game_code': codeGame, 'status': 'waiting', 'created_at': date.toIso8601String(), 'updated_at':date.toIso8601String(),'users':[Globals.userId] });

  sm.showSnackBar(
      SnackBar(content: Text("Game created with code Game : $codeGame $authResponse")));
  return codeGame;
  
}