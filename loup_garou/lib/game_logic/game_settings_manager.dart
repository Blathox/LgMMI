import 'package:loup_garou/game_logic/roles.dart';
import 'package:random_string/random_string.dart';

class GameSettingsManager{
 final String sessionCode = randomAlphaNumeric(6);
  int nbPlayers= 1;
   int nbWolves = 1;
  final int nbPlayersMax;
  final int dayDuration;
  final int nightDuration;
  final List<RoleAction> roles = [];
  GameSettingsManager(this.nbPlayersMax,this.dayDuration,this.nightDuration);

  void addPlayer(){
    nbPlayers++;
  }
  void removePlayer(){
    nbPlayers--;
  }
  void addRole(RoleAction role){
    roles.add(role);
  }
  void removeRole(RoleAction role){
    roles.remove(role);
  }
  void addWolf(){
    addRole(LoupGarou as RoleAction);
    nbWolves++;
  }
  void removeWolf(){
    removeRole(LoupGarou as RoleAction);
    nbWolves--;
  }

}