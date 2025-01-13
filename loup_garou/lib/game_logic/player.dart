import 'package:loup_garou/game_logic/roles.dart';

class Player {

  String name;
  RoleAction role;
  bool isAlive;
  int voteCount = 0;
  bool isLinked = false;
  bool isTargeted = false;
  Player(this.name, this.role, this.isAlive);

  void killed() {
    isAlive = false;
  }

  void revive() {
    isAlive = true;
  }
  void vote(Player player) {
    player.addVote();
    print('$name voted for ${player.name}');
  }

  void resetVote() {
    voteCount = 0;
  }
  void addVote() {
    voteCount++;
  }
  void removeVote() {
    voteCount--;
  }
  setRole(RoleAction role) {
    this.role = role;
  }
  getRole(){
    return role;
  }
  getIsAlive(){
    return isAlive;
  }
  getIsTargeted(){
    return isTargeted;
  }
  setIsTargeted(bool value){
    isTargeted = value;
  }
  getName(){
    return name;
  }
 

  @override
  String toString() {
    return 'Player{name: $name, role: $role, isAlive: $isAlive}';
  }
}