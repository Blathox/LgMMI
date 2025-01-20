import 'package:loup_garou/game_logic/roles.dart';
import 'package:random_string/random_string.dart';

class GameSettingsManager {
  final String sessionCode = randomAlphaNumeric(6);
  int nbPlayers = 6;
  int nbWolves = 1;
  late int nbVillagers;
   int voteDuration; // Add a semicolon here
  final List<RoleAction> roles = [
    LoupGarou(
      name: 'Loup-Garou',
      description: 'Un rôle de loup-garou',
      order: 5,
    ),
    Villageois(
        name: 'Villageois',
        description:
            "Le villageois n'a pas de rôle particulier pendant la nuit, il doit trouver et éliminer les loups lors du vote du village",
        order: 0),
    Sorciere(
      name: 'Sorcière',
      description: 'Un rôle de sorcière',
      order: 3,
    ),
    Chasseur(
      name: 'Chasseur',
      description: 'Un rôle de chasseur',
      order: 4,
    ),
    Cupidon(
      name: 'Cupidon',
      description: 'Un rôle de cupidon',
      order: 1,
    ),
    Voyante(
      name: 'Voyante',
      description: 'Un rôle de voyante',
      order: 2,
    ),
  ];
  late List<RoleAction> rolesSelected;
  String codeGame= '';
  LoupGarou loupGarou = LoupGarou(
    name: 'Loup-Garou',
    description: 'Un loup-garou qui attaque les villageois.',
    order: 1, // Set the appropriate order value
  );
  Villageois villager = Villageois(
      name: 'Villageois',
      description:
          "Le villageois n'a pas de rôle particulier pendant la nuit, il doit trouver et éliminer les loups lors du vote du village",
      order: 0);

  GameSettingsManager(this.voteDuration) {
    rolesSelected = [loupGarou];
    
    nbVillagers = nbPlayers - nbWolves;
    for (int v = 0; v < nbVillagers; v++){
      rolesSelected.add(villager);
    }
  }

  set nbPlayer(int nb) {
    nbPlayers = nb;
  }

  get players {
    print(nbPlayers);
    return nbPlayers;
  }

  get wolves {
    return nbWolves;
  }

  get rolesList {
    return roles;
  }

  get voteDurations {
    return voteDuration;
  }

  int get villagers {
    return nbVillagers;
  }
  set code(String codeGame){
    this.codeGame= codeGame;
  }
  
  set villagers(int nb) {
    nbVillagers = nb;
  }

  void addPlayer() {
    nbPlayers++;
    rolesSelected.add(villager);
    nbVillagers++;
  }

  void removePlayer() {
    nbPlayers--;
    if(rolesSelected.contains(villager)){
      rolesSelected.remove(villager);
      nbVillagers--;
    }
  }

  void addRole(RoleAction role) {
    rolesSelected.add(role);
  }
  void addTime(){
    voteDuration+=30;
  }
  void removeTime(){
    voteDuration-=30;
  }

  void removeRole(RoleAction role) {
    rolesSelected.remove(role);
  }
  int getRoleCount(String role){
    int count =0;

    for (RoleAction roleSelected in rolesSelected){
      if(role == roleSelected.name){

        count++;
      }

    }
    return count;
  }

  void addWolf() {
    addRole(loupGarou);
    removeRole(villager);
    nbWolves++;
    nbVillagers--;
  }

  void removeWolf() {
    removeRole(loupGarou);
    addRole(villager);
    nbWolves--;
    nbVillagers++;
  }
}
