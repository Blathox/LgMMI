import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/roles.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> createGame(
    BuildContext context, Map<String, dynamic> settings,String codeGame) async {
  
  final supabase = Supabase.instance.client;
  final sm = ScaffoldMessenger.of(context);
  final rolesNames = (settings['rolesSelected'] as List<RoleAction>)
      .map((role) => role.name)
      .toList();
  final date = DateTime.now();

  // Mettre à jour settings avec les noms des rôles
  settings['rolesSelected'] = rolesNames;
  var response = await supabase.from('USERS').select('id').eq('id_user', supabase.auth.currentUser!.id).single();
  var id = response['id'];
   final authResponse = await supabase.from('GAMES').insert({'settings': settings, 'game_code': codeGame, 'status': 'waiting', 'created_at': date.toIso8601String(), 'updated_at':date.toIso8601String(),'users':[id] });

  sm.showSnackBar(
      SnackBar(content: Text("Game created with code Game : $codeGame $authResponse")));
  return codeGame;
  
}