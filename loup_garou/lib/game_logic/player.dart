class Player {

  String name;
  String role;
  bool isAlive;
  int voteCount = 0;
  bool isLinked = false;
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
 

  @override
  String toString() {
    return 'Player{name: $name, role: $role, isAlive: $isAlive}';
  }
}