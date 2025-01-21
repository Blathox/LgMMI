import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/game_settings_manager.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Globals {
  static String userId = '';
  static var supabase = Supabase.instance.client;
  static PlayersManager playerManager= PlayersManager();
  static String gameCode= '';
  static GameSettingsManager gameSettings = GameSettingsManager(300);
  static GameManager gameManager = GameManager([]);
}
