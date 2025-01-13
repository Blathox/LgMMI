import 'package:supabase_flutter/supabase_flutter.dart';

class MessageService {
  final supabase = Supabase.instance.client;

  // Envoie un message
  Future<void> sendMessage(String gameId, String playerId, String content) async {
    try {
      await supabase.from('MESSAGES').insert({
        'game_id': gameId,
        'player_id': playerId,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      print("Erreur lors de l'envoi du message : $error");
    }
  }

  // Récupère les anciens messages
  Future<List<Map<String, dynamic>>> fetchMessages(String gameId) async {
    try {
      final response = await supabase
          .from('MESSAGES')
          .select('player_id, content, created_at')
          .eq('game_id', gameId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print("Erreur lors de la récupération des messages : $error");
      return [];
    }
  }

  // Écoute les messages en temps réel
  Stream<List<Map<String, dynamic>>> subscribeToMessages(String gameId) {
    return supabase
        .from('MESSAGES:game_id=eq.$gameId')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }
}
