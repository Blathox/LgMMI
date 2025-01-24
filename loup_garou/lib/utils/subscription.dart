import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loup_garou/game_logic/game_handler.dart';

final supabase = Supabase.instance.client;
late GameHandler gameHandler;

final subscription = supabase
    .from('game_state')
    .stream(primaryKey: ['id'])
    .listen((List<Map<String, dynamic>> data) {
  if (data.isNotEmpty) {
    updateGameState(data.first);
  }
});

void updateGameState(Map<String, dynamic> payload) {
  gameHandler.updateGameMessage("L'état du jeu a été mis à jour !");
}
