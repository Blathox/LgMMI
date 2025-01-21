import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  // Récupération des données utilisateur
  Future<Map<String, String>> fetchUserData() async {
    // Récupérer les données d'authentification
    final userResponse = await _client.auth.getUser();
    final authUser = userResponse.user;

    if (authUser == null) {
      return {
        'username': 'Utilisateur', // Valeur par défaut si non connecté
        'email': 'Non défini',      // Email par défaut
        'creationDate': DateTime.now().toString(), // Date actuelle par défaut
      };
    }

    // Récupérer le username depuis la table USERS
    final userData = await _client
        .from('USERS')
        .select('username')
        .eq('id_user', authUser.id)
        .maybeSingle();

    // Convertir la date de création en DateTime et formater
    String formattedDate = '';
    try {
      final creationDate = DateTime.parse(authUser.createdAt); // Conversion en DateTime
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(creationDate); // Formatage
    } catch (e) {
      formattedDate = authUser.createdAt; // Si la conversion échoue, utilise la valeur brute
    }

    // Retourner le username depuis la table USERS et les autres infos depuis authUser
    return {
      'username': userData?['username'] ?? 'Utilisateur', // Username récupéré depuis USERS
      'email': authUser.email ?? 'Non défini',            // Email depuis authUser
      'creationDate': formattedDate,                       // Date formatée
    };
  }

  // Mise à jour du username
  Future<Map<String, dynamic>?> updatePseudo(String newPseudo) async {
    try {
      // Récupération des informations de l'utilisateur connecté
      final userResponse = await _client.auth.getUser();
      final user = userResponse.user;

      if (user == null) {
        throw Exception('Utilisateur non connecté');
      }

      // Mise à jour du pseudo dans la base de données
      final response = await _client
          .from('USERS')
          .update({'username': newPseudo})
          .eq('id_user', user.id)
          .select();

      // Vérification de la réponse
      if (response.isEmpty) {
        return {'error': 'Mise à jour échouée, aucune donnée retournée'};
      }

      // Retourner la première ligne mise à jour
      if (response.isNotEmpty) {
        return response.first;
      }

      return {'error': 'Type de réponse inattendu'};
    } catch (e) {
      return {'error': e.toString()}; // Gestion des erreurs
    }
  }
}
