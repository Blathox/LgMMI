import 'package:loup_garou/game_logic/roles.dart';

class Player {
  String id; // Identifiant unique du joueur
  String name; // Nom du joueur
  RoleAction role; // Rôle attribué au joueur
  bool isAlive; // Indique si le joueur est vivant
  int voteCount = 0; // Nombre de votes reçus
  bool isLinked = false; // Indique si le joueur est lié à un autre joueur (amoureux, par exemple)
  bool isTargeted = false; // Indique si le joueur est ciblé

  // Constructeur avec tous les paramètres requis
  Player({
    required this.id,
    required this.name,
    required this.role,
    this.isAlive = true, // Par défaut, le joueur est vivant
  });

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

  RoleAction getRole() {
    return role;
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
    return 'Player{id: $id, name: $name, role: ${role.name}, isAlive: $isAlive}';
  }
}
