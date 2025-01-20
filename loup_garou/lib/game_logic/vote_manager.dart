import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loup_garou/game_logic/player.dart';

class VoteManager {
  final supabase = Supabase.instance.client;

  /// Supprime les votes existants et prépare la phase de vote
  Future<void> prepareVoting(String gameId) async {
    print("Préparation de la phase de vote...");
    await supabase.from('VOTES').delete().eq('game_id', gameId);
    print("Tous les votes précédents ont été supprimés.");
  }

  /// Récupère la durée de la phase de vote depuis la base de données
  Future<int> fetchVoteDuration(String gameId) async {
    try {
      final response = await supabase
          .from('GAMES')
          .select('settings->>voteDuration')
          .eq('id', gameId)
          .single();

      if (response.isEmpty) {
        print("Durée de vote introuvable. Valeur par défaut utilisée.");
        return 90; // Par défaut, 90 secondes
      }

      return int.tryParse(response['settings->>voteDuration']) ?? 90;
    } catch (error) {
      print("Erreur lors de la récupération de la durée de vote : $error");
      return 90; // Valeur par défaut en cas d'erreur
    }
  }

  /// Collecte les votes après la durée définie et retourne le joueur éliminé
  Future<Player?> collectVotes(String gameId, List<Player> alivePlayers,
      List<Player> deadPlayers) async {
    print("Phase de vote en cours...");

    // Attendre la durée de la phase de vote
    int voteDuration = await fetchVoteDuration(gameId);
    print("Les joueurs ont $voteDuration secondes pour voter.");
    await Future.delayed(Duration(seconds: voteDuration));

    // Récupérer les votes enregistrés
    final response =
        await supabase.from('VOTES').select('target_id').eq('game_id', gameId);

    if (response.isEmpty) {
      print("Aucun vote enregistré. Personne n'est éliminé.");
      return null;
    }

    // Regrouper et compter les votes
    Map<String, int> voteCounts = {};
    for (var vote in response) {
      String targetId = vote['target_id'];
      voteCounts[targetId] = (voteCounts[targetId] ?? 0) + 1;
    }

    if (voteCounts.isEmpty) {
      print("Aucun vote valide. Personne n'est éliminé.");
      return null;
    }

    // Trouver le maximum de votes
    int maxVotes =
        voteCounts.values.fold(0, (prev, curr) => curr > prev ? curr : prev);
    List<String> mostVotedPlayerIds = voteCounts.entries
        .where((entry) => entry.value == maxVotes)
        .map((entry) => entry.key)
        .toList();

    // Gérer l'égalité
    if (mostVotedPlayerIds.length > 1) {
      print("Égalité entre plusieurs joueurs. Personne n'est éliminé.");
      return null;
    }

    // Identifier le joueur éliminé
    String eliminatedPlayerId = mostVotedPlayerIds.first;
    Player? eliminatedPlayer = alivePlayers.firstWhere(
      (p) => p.playerId == eliminatedPlayerId,
      orElse: () {
        print("Erreur : joueur non trouvé.");
        return Player("Inconnu",
            false); // Renvoie un joueur fictif pour éviter les erreurs
      },
    );

    // Vérifier si le joueur fictif a été retourné
    if (eliminatedPlayer.name == "Inconnu") {
      print("Le joueur n'existe pas dans la liste des vivants.");
      return null;
    }

    // Procéder à l'élimination
    eliminatedPlayer.killed();
    alivePlayers.remove(eliminatedPlayer);
    deadPlayers.add(eliminatedPlayer);

    print(
        "${eliminatedPlayer.name} a été éliminé. Son rôle était : ${eliminatedPlayer.role.name}");
    return eliminatedPlayer;
  }
}
