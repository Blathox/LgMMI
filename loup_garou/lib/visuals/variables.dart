import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Globals {
  static String userId = '';
  static var supabase = Supabase.instance.client;
  static PlayersManager playerManager = PlayersManager();
  static String gameCode = '';
  static GameSettingsManager gameSettings = GameSettingsManager(300);
  static GameManager gameManager = GameManager([]);
  static String gameId='';
  
  /// Initialise les rôles depuis Supabase
  static Future<List<RoleAction>> fetchRolesFromSupabase() async {
    try {
      final response = await supabase.from('ROLES').select();
      // ignore: avoid_print
      print(response);
      if (response.isEmpty) {
        throw Exception('Aucun rôle trouvé dans la base de données.');
      }

      return response.map<RoleAction>((role) {
        switch (role['name']) {
          case 'Loup-Garou':
            return LoupGarou(description: role['description'], order: role['order']);
          case 'Villageois':
            return Villageois(description: role['description'], order: role['order']);
          case 'Sorcière':
            return Sorciere(description: role['description'], order: role['order']);
          case 'Voyante':
            return Voyante(description: role['description'], order: role['order']);
          case 'Chasseur':
            return Chasseur(description: role['description'], order: role['order']);
          case 'Cupidon':
            return Cupidon(description: role['description'], order: role['order']);
          default:
            throw Exception('Rôle inconnu : ${role['name']}');
        }
      }).toList();
    } catch (error) {
      debugPrint('Erreur lors de la récupération des rôles : $error');
      return [];
    }
  }

  /// Liste des rôles, initialisée dynamiquement
  static Future<List<RoleAction>> get rolesList async {
    return await fetchRolesFromSupabase();
  }
}
