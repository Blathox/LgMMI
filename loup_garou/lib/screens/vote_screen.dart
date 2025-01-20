import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoteScreen extends StatelessWidget {
  final String gameId;
  final String voterId;

  const VoteScreen({required this.gameId, required this.voterId, super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    Future<void> submitVote(String targetId) async {
      try {
        await supabase.from('VOTES').insert({
          'game_id': gameId,
          'voter_id': voterId,
          'target_id': targetId,
        });
        print("Vote soumis avec succès.");
        Navigator.of(context).pop(); // Fermer l'écran de vote
      } catch (error) {
        print("Erreur lors de l'enregistrement du vote : $error");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Vote pour éliminer un joueur"),
      ),
      body: FutureBuilder(
        future: supabase.from('PLAYERS').select('id, name').eq('game_id', gameId).eq('isAlive', true),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final players = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return ListTile(
                title: Text(player['name']),
                onTap: () => submitVote(player['id']),
              );
            },
          );
        },
      ),
    );
  }
}
