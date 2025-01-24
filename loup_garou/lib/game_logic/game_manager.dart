// ignore_for_file: avoid_print

import 'dart:core';
import 'package:flutter/material.dart';
import 'package:loup_garou/game_logic/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loup_garou/game_logic/players_manager.dart';
import 'package:loup_garou/game_logic/roles.dart';
import 'phases.dart';

class GameManager {
  // Variables principales
  GamePhase gamePhase = GamePhase(); // Gestion des phases (Jour/Nuit)
  List<RoleAction> roles = []; // Liste des rôles disponibles
  List<RoleAction> rolesAttribued = []; // Liste des rôles attribués
  List<Player> alivePlayers = []; // Joueurs en vie
  List<Player> deadPlayers = []; // Joueurs morts
  List<Player> loversPlayers = []; // Amoureux (spécifique au jeu)
  bool isRunning = false; // État de la partie (en cours ou non)
  bool isWin = false; // Condition de victoire (à implémenter)
  ValueNotifier<String> messageNotifier = ValueNotifier<String>(""); // Notifications pour l'interface

  PlayersManager playersM = PlayersManager(); // Gestionnaire de joueurs
  final supabase = Supabase.instance.client; // Client Supabase pour la synchronisation

  // Constructeur
  GameManager(this.roles);

  // Getters et Setters pour les rôles
  List<RoleAction> get getRoles => roles;
  List<RoleAction> get getRolesAttribued => rolesAttribued;
  set setRoles(List<RoleAction> newRoles) => roles = newRoles;

  // Setter pour le gestionnaire de joueurs
  set playersManager(PlayersManager playersManager) => playersM = playersManager;

  // Getter et setter pour les messages
  String get getMessage => messageNotifier.value;
  void updateMessage(String newMessage) => messageNotifier.value = newMessage;

  /// ============================================
  /// Démarrage et gestion de la partie
  /// ============================================

  // Lancer une partie
  Future<void> startGame(BuildContext context, String gameId) async {
    if (isRunning) {
      print("La partie est déjà en cours.");
      return;
    }

    isRunning = true;
    updateMessage("La partie commence !");
    gamePhase.currentPhase = Phase.Night;

    // Initialisation de la partie
    await attribuerRoles(); // Distribution des rôles
    await supabase
        .from('GAMES')
        .update({'is_running': true, 'current_phase': 'Night'})
        .eq('id', gameId);

    // Début des phases
    await processNightActions(context); // Phase de nuit
    await processDayActions(context, gameId); // Phase de jour
  }

  // Avancer dans les phases du jeu
  Future<void> processGame(BuildContext context, String gameId) async {
    gamePhase.switchPhase(); // Alterne entre Jour et Nuit
    print("Phase actuelle : ${gamePhase.currentPhase}");

    if (gamePhase.currentPhase == Phase.Night) {
      await processNightActions(context);
    } else if (gamePhase.currentPhase == Phase.Day) {
      await processDayActions(context, gameId);
    }
  }

  /// ============================================
  /// Phases du jeu (Jour et Nuit)
  /// ============================================

  // Actions de la phase de nuit
  Future<void> processNightActions(BuildContext context) async {
    updateMessage("Le village s'endort...");
    print("Phase de nuit : traitement des rôles.");

    for (RoleAction role in rolesAttribued) {
      print("Action du rôle : ${role.getName}");
      role.performAction(context, playersM); // Action spécifique au rôle
    }

    print("Fin de la phase de nuit.");
  }

  // Actions de la phase de jour
  Future<void> processDayActions(BuildContext context, String gameId) async {
    updateMessage("Le village se réveille...");
    print("Phase de jour : traitement des votes.");

    // Récupération des joueurs tués pendant la nuit
    List<Map<String, dynamic>> killedPlayers = await fetchKilledPlayers();
    for (var player in killedPlayers) {
      print("Joueur tué : ${player['name']} (Rôle : ${player['role']})");
    }

    // Récupération de la durée de vote
    int voteDuration = await fetchVoteDuration(gameId);
    print("Durée de la phase de vote : $voteDuration secondes.");

    // Attente de la durée de vote
    await Future.delayed(Duration(seconds: voteDuration));

    print("Fin de la phase de vote.");
    gamePhase.switchPhase(); // Passe à la phase suivante
  }

  /// ============================================
  /// Distribution des rôles
  /// ============================================

  // Distribution des rôles aux joueurs
  Future<void> attribuerRoles() async {
    updateMessage("Attribution des rôles...");
    if (roles.isEmpty) {
      throw Exception("La liste des rôles est vide. Impossible d'attribuer les rôles.");
    }
    if (roles.length < playersM.playerList.length) {
      throw Exception("Pas assez de rôles pour le nombre de joueurs.");
    }

    roles.shuffle(); // Mélange des rôles pour une distribution aléatoire
    List<RoleAction> tempRoles = List.from(roles); // Copie temporaire

    print("| - Attribution des rôles - |");
    for (int i = 0; i < playersM.playerList.length; i++) {
      playersM.playerList[i].setRole(tempRoles[i]); // Assigne un rôle
      rolesAttribued.add(tempRoles[i]); // Ajoute à la liste des rôles attribués
      print("${playersM.playerList[i].getName()} : ${tempRoles[i].getName}");
    }

    roles.clear(); // Vide la liste des rôles
    rolesAttribued.sort((a, b) => a.order.compareTo(b.order)); // Trie les rôles attribués
    updateMessage("Les rôles ont été attribués.");
  }

  /// ============================================
  /// Méthodes auxiliaires (Base de données)
  /// ============================================

  // Récupère les joueurs tués pendant la nuit
  Future<List<Map<String, dynamic>>> fetchKilledPlayers() async {
    try {
      final response = await supabase
          .from('PLAYERS')
          .select('name, role')
          .eq('killedAtNight', true);

      return response.isEmpty ? [] : List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print("Erreur lors de la récupération des joueurs tués : $error");
      return [];
    }
  }

  // Récupère la durée de vote configurée
  Future<int> fetchVoteDuration(String gameId) async {
    try {
      final response = await supabase
          .from('GAMES')
          .select('settings->>voteDuration')
          .eq('id', gameId)
          .single();

      return int.tryParse(response['settings->>voteDuration'] ?? '') ?? 90;
    } catch (error) {
      print("Erreur lors de la récupération de la durée de vote : $error");
      return 90; // Durée par défaut
    }
  }

}

  /// ============================================
  /// Composant RoleReveal ( permet d'afficher son rôle sur l'écran)
  /// ============================================ 
  