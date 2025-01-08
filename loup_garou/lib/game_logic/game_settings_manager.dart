import 'package:loup_garou/game_logic/roles.dart';
import 'package:random_string/random_string.dart';

class GameSettingsManager{
 final String sessionCode = randomAlphaNumeric(6);
  int nbPlayers= 1;
   int nbWolves = 1;
  final int nbPlayersMax;
  final int voteDuration;
  final List<RoleAction> roles = [];

  GameSettingsManager(this.nbPlayersMax,this.voteDuration);

   setNbPlayers(int nb){
    nbPlayers = nb;
  }
  getPlayers(){
    return nbPlayers;
  }
  
  getWolves(){
    return nbWolves;
  }
 
  getRoles(){
    return roles;
  }
  getVoteDuration(){
    return voteDuration;
  }
  setRoleDuration(){
    return voteDuration;
  }

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