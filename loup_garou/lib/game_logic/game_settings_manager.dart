import 'package:loup_garou/game_logic/roles.dart';
import 'package:loup_garou/visuals/variables.dart';
import 'package:random_string/random_string.dart';

class GameSettingsManager {
  final String sessionCode = randomAlphaNumeric(6);
  int nbPlayers = 6;
  int nbWolves = 1;
  late int nbVillagers;
  int voteDuration;
  late List<RoleAction> roles; // Liste complète des rôles
  late List<RoleAction> rolesSelected; // Liste des rôles assignés
  final List<RoleAction> optionalRoles = []; // Liste des rôles facultatifs
  String codeGame = '';

  GameSettingsManager(this.voteDuration);

  /// Initialise les rôles depuis Globals
  Future<void> initializeRoles() async {
    roles = await Globals.rolesList;
    _recalculateRoles();
  }

  int get players{
    return nbPlayers;
  }
  int get wolves{
    return nbWolves;
  }
  int get villagers{
    return nbVillagers;
  }
  int get voteTime{
    return voteDuration;
  }
  /// Ajoute ou retire un rôle spécifique dans les rôles facultatifs
  void toggleRole(RoleAction role, bool add) {
    if (add) {
      if (!optionalRoles.contains(role)) {
        optionalRoles.add(role);
      }
    } else {
      optionalRoles.remove(role);
    }
    _recalculateRoles();
  }

  /// Recalcule `rolesSelected` en fonction des joueurs, des loups et des rôles facultatifs
  void _recalculateRoles() {
    if (roles.isEmpty) {
      throw Exception('Les rôles doivent être initialisés avant de recalculer.');
    }

    rolesSelected = [];

    // Ajouter les loups-garous
    rolesSelected.addAll(roles.whereType<LoupGarou>().take(nbWolves));

    // Calculer le nombre de villageois
    nbVillagers = nbPlayers - nbWolves - optionalRoles.length;

    if (nbVillagers < 0) {
      throw Exception("Le nombre de villageois ne peut pas être négatif.");
    }

    // Ajouter les villageois
    rolesSelected.addAll(
      roles.whereType<Villageois>().take(nbVillagers),
    );

    // Ajouter les rôles facultatifs
    rolesSelected.addAll(optionalRoles);
  }

  /// Ajoute un joueur et met à jour les rôles
  void addPlayer() {
    nbPlayers++;
    _recalculateRoles();
  }

  /// Supprime un joueur et met à jour les rôles
  void removePlayer() {
    if (nbPlayers > 0) {
      nbPlayers--;
      _recalculateRoles();
    }
  }

  /// Ajoute un loup et met à jour les rôles
  void addWolf() {
    if (nbWolves < nbPlayers - 1) { // Toujours garder au moins un villageois
      nbWolves++;
      _recalculateRoles();
    }
  }

  /// Supprime un loup et met à jour les rôles
  void removeWolf() {
    if (nbWolves > 0) {
      nbWolves--;
      _recalculateRoles();
    }
  }

  /// Ajoute du temps de vote
  void addTime() {
    voteDuration += 30;
  }

  /// Retire du temps de vote
  void removeTime() {
    if (voteDuration > 30) {
      voteDuration -= 30;
    }
  }

  /// Compte le nombre d'occurrences d'un rôle donné dans `rolesSelected`
  int getRoleCount(String roleName) {
    return rolesSelected.where((role) => role.name == roleName).length;
  }
}
