import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/visuals/variables.dart';


Future<String> createGame(
    BuildContext context, GameSettingsManager settings,String codeGame) async {
  
  final sm = ScaffoldMessenger.of(context);

  final date = DateTime.now();
print(codeGame);
  // Mettre à jour settings avec les noms des rôles
var newSettings= {
  'rolesSelected': settings.rolesSelected.map((role)=>role.name).toList(),
  'loups': settings.wolves,
  "villageois": settings.villagers,
  "nbJoueurs": settings.players,
  "voteDuration": settings.voteTime
};
print(newSettings);

   final authResponse = await Globals.supabase.from('GAMES').insert({'settings': newSettings, 'game_code': codeGame, 'status': 'waiting', 'created_at': date.toIso8601String(), 'updated_at':date.toIso8601String(),'users':[Globals.userId] }).select('id').single();
  Globals.gameId= authResponse['id'];
  sm.showSnackBar(
      SnackBar(content: Text("Game created with code Game : $codeGame $authResponse")));
  return codeGame;
  
}