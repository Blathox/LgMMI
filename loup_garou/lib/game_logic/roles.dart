abstract class RoleAction {
  final String name;
  final String description;

  RoleAction({required this.name, required this.description});


  void performAction();
}

////////////////////////////////////////////////////////////////

class LoupGarou extends RoleAction {
  List<String> availableTargets = []; 
  String? chosenTarget; 

  LoupGarou({required super.name, required super.description});

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
  Villageois({required super.name, required super.description});

  @override
  void performAction() {
    print("Le Villageois participe aux votes pour éliminer un joueur.");
  }
}

