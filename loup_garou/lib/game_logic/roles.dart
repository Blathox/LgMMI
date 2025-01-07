import 'package:loup_garou/game_logic/game_manager.dart';
import 'package:loup_garou/game_logic/player.dart';

abstract class RoleAction {
  final String name;
  final int order;
  final String description;
  RoleAction({required this.name, required this.description, required this.order});


  void performAction();
}

////////////////////////////////////////////////////////////////

class LoupGarou extends RoleAction {

  List<String> availableTargets = []; 
  String? chosenTarget; 

  LoupGarou({required super.name, required super.description, required super.order});

  @override
  void performAction() {
    if (availableTargets.isEmpty) {
      print("Aucune cible disponible pour les Loups-Garous.");
      return;
    }

    if (chosenTarget == null) {
      print("Le Loup-Garou doit choisir une cible.");
      return;
    }

    print("Le Loup-Garou attaque $chosenTarget !");
    eliminateTarget(chosenTarget!);
  }

  void setAvailableTargets(List<String> players) {
    availableTargets = players;
    print("Cibles disponibles pour les Loup-Garous : ${availableTargets.join(', ')}");
  }

  void selectTarget(String targetName) {
    if (!availableTargets.contains(targetName)) {
      print("$targetName n'est pas une cible valide.");
      return;
    }
    chosenTarget = targetName;
    print("Le Loup-Garou a choisi d'attaquer : $targetName");
  }

  void eliminateTarget(String targetName) {
    print("$targetName a été éliminé par les Loups-Garous.");
    // logique pour mettre à jour l'état du joueur dans le jeu.
  }
}



////////////////////////////////////////////////////////////////

class Villageois extends RoleAction {
  Villageois({required super.name, required super.description, required super.order});

  @override
  void performAction() {
    print("Le Villageois participe aux votes pour éliminer un joueur.");
  }
}
class Sorciere extends Villageois {
  Sorciere({required super.name, required super.description, required super.order});
  
  List<Player>? get players => null;

  @override
  void performAction() {
    print("La Sorcière peut sauver ou éliminer un joueur.");
  }

 void savePlayer(String playerName, GameManager gameManager) {
  Player? player = gameManager.getPlayerByName(playerName);
  if (player == null) {
    print("Le joueur $playerName n'existe pas.");
    return;
  }else{
      player.revive();
  print("La Sorcière a sauvé $playerName.");

  }
}
  void killPlayer(String playerName,GameManager gameManager) {

    Player? player = gameManager.getPlayerByName(playerName);
    if (player == null) {
      print("Le joueur $playerName n'existe pas.");
      return;
    }
    else{
          player.killed();
         print("La Sorcière a éliminé $playerName.");
 }
  }
  
}
class Chasseur extends Villageois {
  Chasseur({required super.name, required super.description, required super.order});

  @override
  void performAction() {
    print("Le Chasseur peut éliminer un joueur avant de mourir.");
  }
    void killPlayer(String playerName,GameManager gameManager) {

    Player? player = gameManager.getPlayerByName(playerName);
    if (player == null) {
      print("Le joueur $playerName n'existe pas.");
      return;
    }
    else{
          player.killed();
         print("Le chasseur a éliminé $playerName.");
 }
  }
}
class Cupidon extends Villageois {
  Cupidon({required super.name, required super.description, required super.order});

  @override
  void performAction() {
    print("Cupidon peut lier deux joueurs.");
  }
  void linkPlayers(String player1, String player2, GameManager gameManager) {
  Player? p1 = gameManager.getPlayerByName(player1);
  Player? p2 = gameManager.getPlayerByName(player2);
  if (p1 == null || p2 == null) {
    print("Les joueurs $player1 et $player2 doivent être présents dans la partie.");
    return;
  } else {
    gameManager.addPlayerLinked(p1, p2);
    print("Cupidon a lié $player1 et $player2.");
  }
}}
class Voyante extends Villageois {
  Voyante({required super.name, required super.description, required super.order});

  @override
  void performAction() {
    print("La Voyante peut voir le rôle d'un joueur.");
  }
  void seeRole(String playerName, GameManager gameManager) {
  Player? player = gameManager.getPlayerByName(playerName);
  if (player == null) {
    print("Le joueur $playerName n'existe pas.");
    return;
  } else {
    print("Le rôle de $playerName est : ${player.role}");
  }
}
}

