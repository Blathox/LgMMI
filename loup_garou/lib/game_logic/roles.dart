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

  LoupGarou({required String name, required String description})
      : super(name: name, description: description);

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
///
///import './lib/roles.dart'; // Assure-toi que le chemin correspond à ton fichier roles.dart

void main() {
  // Étape 1 : Créer une instance de Loup-Garou
  LoupGarou loupGarou = LoupGarou(
    name: "Loup-Garou",
    description: "Élimine un joueur chaque nuit.",
  );

  // Étape 2 : Définir les cibles disponibles
  print("=== Test : Définir les cibles disponibles ===");
  loupGarou.setAvailableTargets(["Thomas", "Charlie", "Oriane"]);

  // Étape 3 : Choisir une cible valide
  print("\n=== Test : Choisir une cible valide ===");
  loupGarou.selectTarget("Charlie");

  // Étape 4 : Effectuer l'attaque
  print("\n=== Test : Effectuer l'attaque ===");
  loupGarou.performAction();

  // Étape 5 : Tester avec une cible invalide
  print("\n=== Test : Choisir une cible invalide ===");
  loupGarou.selectTarget("Alex");

  // Étape 6 : Tester sans cible choisie
  print("\n=== Test : Effectuer l'attaque sans cible choisie ===");
  loupGarou.chosenTarget = null; // Réinitialiser la cible
  loupGarou.performAction();
}