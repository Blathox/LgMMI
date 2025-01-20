import 'package:loup_garou/game_logic/roles.dart';

class Player {
  String name; // Nom du joueur
  RoleAction role; // Rôle attribué au joueur
  late String roleName;
  bool isAlive; // Statut : vivant ou mort
  int voteCount = 0; // Nombre de votes reçus
  bool isLinked = false; // Joueur lié (Cupidon, etc.)
  bool isTargeted = false; // Joueur ciblé par une action
  String idPlayer = ''; // Identifiant unique du joueur

  // Constructeur
  Player(this.name, this.isAlive, {RoleAction? initialRole})
      : role = initialRole ?? Villageois(description: '', order: 0);

  // Gestion de l'identifiant
  String get playerId => idPlayer;
  set playerId(String id) => idPlayer = id;

  // Méthodes pour gérer l'état du joueur
  void killed() {
    isAlive = false;
    print('$name a été tué.');
  }

  void revive() {
    isAlive = true;
    print('$name a été réanimé.');
  }

  void vote(Player player) {
    player.addVote();
    print('$name a voté contre ${player.name}.');
  }

  void resetVote() {
    voteCount = 0;
  }

  void addVote() {
    voteCount++;
  }

  void removeVote() {
    if (voteCount > 0) {
      voteCount--;
    }
  }

  void setRole(RoleAction role) {
    this.role = role;
  }

  RoleAction getRole (){
    return role;
  }
  String getRoleName(){
    return role.getName;
  }

  bool getIsAlive() {
    return isAlive;
  }

  bool getIsTargeted() {
    return isTargeted;
  }

  void setIsTargeted(bool value) {
    isTargeted = value;
  }

  String getName() {
    return name;
  }

  @override
  String toString() {
    return 'Player{name: $name, isAlive: $isAlive, role: ${role.name}}';
  }
}
