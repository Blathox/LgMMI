import 'package:loup_garou/game_logic/roles.dart';

class Player {

  String name;
  late RoleAction role;
  late String roleName;
  bool isAlive;
  int voteCount = 0;
  String idPlayer='';
  bool isLinked = false;
  bool isTargeted = false;
  Player(this.name, this.isAlive){
    role = Villageois(description: '', order: 0);
  }

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
  String getIdPlayer(){
    return idPlayer;
  }

  @override
  String toString() {
    return 'Player{name: $name, isAlive: $isAlive}';
  }
}
